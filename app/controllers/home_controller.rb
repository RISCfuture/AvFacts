# Root controller for the app. The {#index} action renders the page layout.

class HomeController < ApplicationController

  # Catch-all action for all non-API routes. Renders the page structure and
  # app container. The Vue.js app then parses the URL and renders the
  # appropriate page as a single-page application.
  #
  # Routes
  # ------
  #
  # * `GET /`

  def index
  end
end
