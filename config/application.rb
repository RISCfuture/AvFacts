require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AvFacts
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.autoloader = :zeitwerk

    config.generators do |g|
      g.template_engine     :slim
      g.test_framework      :rspec, fixture: true, views: false
      g.integration_tool    :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.active_job.queue_name_prefix = "avfacts_#{Rails.env}"

    config.active_record.schema_format = :sql

    require 'audio_analyzer'
    config.active_storage.analyzers.append AudioAnalyzer
  end
end

if Rails.env.production?
  FFMPEG.ffmpeg_binary  = '/var/www/www.avfacts.org/shared/bin/ffmpeg'
  FFMPEG.ffprobe_binary = '/var/www/www.avfacts.org/shared/bin/ffprobe'
end
