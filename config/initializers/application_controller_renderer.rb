# Be sure to restart your server when you modify this file.

ActiveSupport::Reloader.to_prepare do
  case Rails.env
    when 'development'
      ApplicationController.renderer.defaults.merge! http_host: 'localhost',
                                                     port:      5000,
                                                     https:     false

    when 'test'
      ApplicationController.renderer.defaults.merge! http_host: 'test.host',
                                                     https:     false

    when 'production'
      ApplicationController.renderer.defaults.merge! http_host: 'www.avfacts.org',
                                                     https:     true

  end
end
