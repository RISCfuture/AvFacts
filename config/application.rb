require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
#require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AvFacts
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators do |g|
      g.template_engine     :slim
      g.test_framework      :rspec, fixture: true, views: false
      g.integration_tool    :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.active_job.queue_name_prefix = "avfacts_#{Rails.env}"

    require 'audio_analyzer'
    config.active_storage.analyzers.append AudioAnalyzer
  end
end

if Rails.env.production?
  FFMPEG.ffmpeg_binary  = '/var/www/www.avfacts.org/shared/bin/ffmpeg'
  FFMPEG.ffprobe_binary = '/var/www/www.avfacts.org/shared/bin/ffprobe'
end
