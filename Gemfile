source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

# FRAMEWORK
gem 'bootsnap'
gem 'configoro'
gem 'rails', '5.2.2.1'
gem 'sidekiq'

# MODELS
gem 'bcrypt'
gem 'mini_magick'
gem 'pg'
gem 'streamio-ffmpeg'
gem 'validates_timeliness'

# CONTROLLERS
gem 'responders'

# VIEWS
# HTML
gem 'slim-rails'
# JS
gem 'webpacker'
# JSON
gem 'jbuilder'
# XML
gem 'builder'

# OTHER
gem 'json'
gem 'nokogiri'

group :development do
  gem 'listen'
  gem 'puma'

  # DEVELOPMENT
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  # SPECS
  gem 'rails-controller-testing'
  gem 'rspec-rails'

  # ISOLATION
  gem 'database_cleaner'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'timecop'
  gem 'webmock'

  # FACTORIES
  gem 'factory_bot_rails'
  gem 'ffaker'
end

group :production do
  # CACHE
  gem 'redis-rack-cache'
  gem 'redis-rails'

  # PAPERCLIP
  gem 'aws-sdk-s3'
end

group :doc do
  gem 'redcarpet'
  gem 'yard', require: nil
end
