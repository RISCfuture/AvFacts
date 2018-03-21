# RESTful controller for working with {Episode Episodes}. This controller
# handles both JSON requests from the front-end, the RSS format for podcast
# readers, and requests for podcast MP3 files.

class EpisodesController < ApplicationController
  include Streaming

  before_action :find_episode, except: %i[index create]
  before_action :admin_required, except: %i[index show]

  respond_to :json
  respond_to :rss, only: :index
  respond_to :mp3, only: :show

  # **JSON**: This action renders a list of podcasts for the front-end
  # `/episodes` view. Only published, not-blocked episodes are included unless
  # the user is logged in. Only publicly-published episode metadata is included
  # (so not scripts).
  #
  # **RSS**: This action renders the RSS feed for podcast readers. The feed is
  # in iTunes Podcast XML format, which is a superset of the normal W3 Atom
  # format.
  #
  # Episodes are normally ordered by their number, with the newest episode
  # first. A textual filter query can be provided with the `filter` query
  # parameter; if provided, the results will be ordered by relevance.
  #
  # A maximum of 50 episodes are returned per request. Pagination is handled
  # with the `before` query parameter. The `X-Next-Page` response header will
  # include the URL to retrieve the next 50 podcasts.
  #
  # Routes
  # ------
  #
  # * `GET /episodes.json`
  # * `GET /episodes.rss`
  #
  # Query Parameters
  # ----------------
  #
  # |          |                                                                                                                                                                                   |
  # |:---------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  # | `before` | An optional Episode number. Only episodes prior to that number will be included.                                                                                                  |
  # | `filter` | An optional search query. Only episodes matching that search query will be included. The search includes the title and description, as well as private fields such as the script. |

  def index
    @episodes = admin? ? Episode.all : Episode.published

    if request.format.json? && !admin?
      @episodes = @episodes.where(blocked: false)
    end

    if params[:before].present?
      @episodes = @episodes.where('number < ?', params[:before])
    end

    if params[:filter].present?
      @episodes = @episodes.
          select('*, ts_rank_cd(fulltext_search, query) AS search_rank').
          from("#{Episode.quoted_table_name}, plainto_tsquery(#{Episode.connection.quote params[:filter]}) query").
          where('fulltext_search @@ query')
    end

    @last_page = @episodes.empty? || @episodes.pluck(:number).include?(Episode.minimum(:number))
    unless @last_page
      response.headers['X-Next-Page'] = episodes_url(before: @episodes.minimum(:number), filter: params[:filter].presence, format: params[:format])
    end

    if params[:filter].present?
      @episodes = @episodes.order('search_rank DESC')
    else
      @episodes = @episodes.order(number: :desc)
    end

    @episodes = @episodes.with_attached_audio.with_attached_image.limit(50)

    respond_with :episodes do |format|
      format.rss do
        return unless stale?(@episodes)
      end
    end
  end

  # **JSON:** Renders complete information about a podcast episode in JSON
  # format. This action requires an active user session and includes private
  # fields, like the script.
  #
  # **MP3** or **AAC**: Streams the transcoded episode audio in MP3 or AAC
  # format.
  #
  # Routes
  # ------
  #
  # * `GET /episode/:id.json`
  # * `GET /episode/:id.mp3`
  # * `GET /episode/:id.m4a`
  #
  # Path Parameters
  # ---------------
  #
  # |      |                                       |
  # |:-----|:--------------------------------------|
  # | `id` | The Episode number (not database ID). |

  def show
    respond_with @episode do |format|
      format.json do
        return unauthorized_response unless admin?
      end

      format.mp3 do
        return head(:not_found) unless @episode.processed?
        redirect_to @episode.mp3.public_cdn_url
        #stream @episode.mp3.public_cdn_url
      end

      format.m4a do
        return head(:not_found) unless @episode.processed?
        redirect_to @episode.aac.public_cdn_url
        #stream @episode.aac.public_cdn_url
      end
    end
  end

  # Creates a new episode from the given parameters.
  #
  # Routes
  # ------
  #
  # * `POST /episodes.json`
  #
  # Body Parameters
  # ---------------
  #
  # |           |                                           |
  # |:----------|:------------------------------------------|
  # | `episode` | Parameterized hash of Episode attributes. |

  def create
    @episode = Episode.create(episode_params)
    respond_with @episode
  end

  # Updates an episode from the given parameters.
  #
  # Routes
  # ------
  #
  # * `PATCH /episodes/:id.json`
  #
  # Path Parameters
  # ---------------
  #
  # |      |
  #   |
  # |:-----|:--------------------------------------|
  # | `id` | The Episode number (not database ID). |
  #
  # Body Parameters
  # ---------------
  #
  # |           |                                           |
  # |:----------|:------------------------------------------|
  # | `episode` | Parameterized hash of Episode attributes. |

  def update
    @episode.update(episode_params)
    respond_with @episode
  end

  # Deletes an Episode.
  #
  # Routes
  # ------
  #
  # * `DELETE /episodes/:id.json`
  #
  # Path Parameters
  # ---------------
  #
  # |      |                                       |
  # |:-----|:--------------------------------------|
  # | `id` | The Episode number (not database ID). |


  def destroy
    @episode.destroy
    respond_with @episode
  end

  private

  def find_episode
    @episode = Episode.find_by_number!(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:number, :title, :author, :description,
                                    :script, :published_at, :explicit, :audio,
                                    :image, :summary, :subtitle, :blocked)
  end
end
