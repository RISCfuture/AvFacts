require 'rails_helper'

RSpec.describe EpisodesController, type: :controller do
  describe '#index' do
    context '[JSON]' do
      render_views

      context '[filtering]' do
        before :each do
          @episodes = 5.times.map { |i| FactoryBot.create :episode, number: i + 100, processed: true }
          @episodes.shuffle.each_with_index { |e, i| e.update_attribute :number, i + 1 }

          # red herrings
          @unpublished = FactoryBot.create(:episode, processed: true, published_at: 1.day.from_now)
          @blocked     = FactoryBot.create(:episode, processed: true, blocked: true)
          @draft       = FactoryBot.create(:episode, audio: nil)
        end

        it "should list episodes in order filtering unpublished episodes" do
          get :index, params: {format: 'json'}
          expect(response.status).to eql(200)
          json = JSON.parse(response.body)
          expect(json.map { |j| j['number'] }).
              to eql(@episodes.map(&:number).sort.reverse)
        end

        it "should not withhold blocked episodes for JSON requests from admins" do
          login_as_admin
          get :index, params: {format: 'json'}
          json = JSON.parse(response.body)
          expect(json.map { |j| j['number'] }).
              to include(@blocked.number)
        end

        it "should not withhold unpublished episodes for JSON requests from admins" do
          login_as_admin
          get :index, params: {format: 'json'}
          json = JSON.parse(response.body)
          expect(json.map { |j| j['number'] }).
              to include(@unpublished.number, @draft.number)
        end
      end

      context '[pagination]' do
        before :each do
          @episodes = 15.times.map { |i| FactoryBot.create :episode, number: i + 100, processed: true }
          @episodes.shuffle.each_with_index { |e, i| e.update_attribute :number, i + 1 }
        end

        it "should paginate" do
          get :index, params: {format: 'json'}
          expect(response.headers['X-Next-Page']).to eql('http://test.host/episodes.json?before=6')
          json = JSON.parse(response.body)
          expect(json.map { |j| j['number'] }).
              to eql(@episodes.map(&:number).sort.reverse[0, 10])

          get :index, params: {format: 'json', before: '6'}
          expect(response.headers['X-Next-Page']).to be_nil
          json = JSON.parse(response.body)
          expect(json.map { |j| j['number'] }).
              to eql(@episodes.map(&:number).sort.reverse[10, 10])
        end

        it "should accept a 'before' parameter" do
          get :index, params: {before: '3', format: 'json'}
          json = JSON.parse(response.body)
          expect(json.map { |j| j['number'] }).
              to eql(@episodes.map(&:number).sort.reverse[-2..-1])
        end
      end

      context '[searching]' do
        before :each do
          @included = FactoryBot.create_list(:episode, 3, script: "SearchTerm #{FFaker::HipsterIpsum.sentence}", processed: true)
          @no_match = FactoryBot.create(:episode, script: FFaker::HipsterIpsum.sentence, processed: true)
        end

        it "should accept a search query" do
          get :index, params: {filter: 'SearchTerm', format: 'json'}
          json = JSON.parse(response.body).map { |j| j['number'] }
          expect(json).to match_array(@included.map(&:number))
        end
      end
    end

    context '[RSS]' do
      before :each do
        @episodes = 3.times.map { |i| FactoryBot.create :episode, number: i + 100 }
        @episodes.shuffle.each_with_index { |e, i| e.update_attribute :number, i + 1 }

        # red herrings
        @unpublished = FactoryBot.create(:episode, processed: true, published_at: 1.day.from_now)
        @blocked     = FactoryBot.create(:episode, processed: true, blocked: true)
        @draft       = FactoryBot.create(:episode, audio: nil)

        [*@episodes, @unpublished, @blocked].each(&:preprocess!)
      end

      render_views

      it "should render the RSS feed" do
        get :index, params: {format: 'rss'}
        expect(response.status).to eql(200)
        expect(response).to render_template('index')
      end

      it "should not withhold blocked episodes for RSS" do
        get :index, params: {format: 'rss'}
        expect(assigns(:episodes)).to include(@blocked)
      end
    end
  end

  describe '#show' do
    before :each do
      @episode = FactoryBot.create(:episode)
      @episode.preprocess!
    end

    context '[JSON]' do
      it "should 401 when unauthenticated" do
        get :show, params: {id: @episode.to_param, format: 'json'}
        expect(response.status).to eql(401)
      end

      context '[logged in]' do
        before(:each) { login_as_admin }

        it "should render the show template" do
          get :show, params: {id: @episode.to_param, format: 'json'}
          expect(response.status).to eql(200)
          expect(response).to render_template('show')
        end

        it "should show an episode" do
          get :show, params: {id: @episode.to_param, format: 'json'}
          expect(assigns(:episode)).to eql(@episode)
        end
      end
    end

    %w[mp3 aac].each do |format|
      context "[#{format.upcase}]" do
        before :each do
          stub_request(:get, /^http:\/\/test\.host\/rails\/active_storage\/disk/).
              to_return(status: 200, body: "this is not a very well-formatted audio file")
        end

        it "should stream" do
          get :show, params: {id: @episode.to_param, format: format}
          expect(response.status).to eql(200)
          expect(response.body).to eql("this is not a very well-formatted audio file")
        end

        it "should 404 if the audio hasn't been added yet" do
          episode = FactoryBot.create(:episode, audio: nil)
          get :show, params: {id: episode.to_param, format: format}
          expect(response.status).to eql(404)
          expect(response.body).to be_empty
        end

        it "should 404 if the audio hasn't been processed yet" do
          episode = FactoryBot.create(:episode)
          allow(episode.aac).to receive(:processed?).and_return(false)
          get :show, params: {id: episode.to_param, format: format}
          expect(response.status).to eql(404)
          expect(response.body).to be_empty
        end
      end
    end
  end

  describe '#create' do
    before :each do
      @episode_params         = FactoryBot.attributes_for(:episode)
      @episode_params[:audio] = fixture_file_upload('audio.aif', 'audio/aiff')
      @episode_params[:image] = fixture_file_upload('image.jpg', 'image/jpeg')
      login_as_admin
    end

    it "should require admin" do
      session[:user_id] = nil
      post :create, params: {episode: @episode_params, format: 'json'}
      expect(response.status).to eql(401)
    end

    it "should make an episode" do
      post :create, params: {episode: @episode_params, format: 'json'}
      expect(response.status).to eql(201)
      expect(Episode.count).to eql(1)
      expect(Episode.first.title).to eql(@episode_params[:title])
    end

    it "should handle validation errors" do
      post :create, params: {episode: @episode_params.merge(title: " "), format: 'json'}
      expect(response.status).to eql(422)
    end
  end

  describe '#update' do
    before :each do
      @episode = FactoryBot.create(:episode)
      login_as_admin
    end

    it "should require admin" do
      session[:user_id] = nil
      patch :update, params: {id: @episode.to_param, episode: {title: "New Title"}, format: 'json'}
      expect(response.status).to eql(401)
    end

    it "should update an episode" do
      patch :update, params: {id: @episode.to_param, episode: {title: "New Title"}, format: 'json'}
      expect(response.status).to eql(204)
      expect(@episode.reload.title).to eql("New Title")
    end

    it "should handle validation errors" do
      patch :update, params: {id: @episode.to_param, episode: {title: " "}, format: 'json'}
      expect(response.status).to eql(422)
    end
  end

  describe '#destroy' do
    before :each do
      @episode = FactoryBot.create(:episode)
      login_as_admin
    end

    it "should require admin" do
      session[:user_id] = nil
      delete :destroy, params: {id: @episode.to_param, format: 'json'}
      expect(response.status).to eql(401)
    end

    it "should delete an episode" do
      delete :destroy, params: {id: @episode.to_param, format: 'json'}
      expect(response.status).to eql(204)
      expect { @episode.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
