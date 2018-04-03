source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# FRAMEWORK
gem 'rails', '5.2.0.rc2'
gem 'configoro'
gem 'bootsnap'
gem 'sidekiq'

# MODELS
gem 'pg'
gem 'validates_timeliness'
gem 'mini_magick'
gem 'streamio-ffmpeg'
gem 'bcrypt'

# CONTROLLERS
gem 'responders'

# VIEWS
# HTML
gem 'slim-rails'
# JS
gem 'webpacker', github: 'rails/webpacker'
# JSON
gem 'jbuilder'
# XML
gem 'builder'

# OTHER
gem 'nokogiri'
gem 'json'

group :development do
  gem 'puma'
  gem 'listen'

  # DEVELOPMENT
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  # SPECS
  gem 'rspec-rails'
  gem 'rails-controller-testing'

  # ISOLATION
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webmock'
  gem 'fakefs', require: 'fakefs/safe'

  # FACTORIES
  gem 'factory_bot_rails'
  gem 'ffaker'
end

group :production do
  # CACHE
  gem 'redis-rails'
  gem 'redis-rack-cache'

  # PAPERCLIP
  gem 'aws-sdk-s3'
end

group :doc do
  gem 'redcarpet'
  gem 'yard', require: nil
end
