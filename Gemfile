source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

# FRAMEWORK
gem 'rails', '5.2.0.beta2'
gem 'configoro'
gem 'bootsnap'
gem 'sidekiq'

# MODELS
gem 'pg', '< 1.0'
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

group :development do
  gem 'puma'
  gem 'listen'
  
  # DEVELOPMENT
  gem 'better_errors'
  gem 'binding_of_caller'
  
  # DEPLOYMENT
  gem 'capistrano', require: nil
  gem 'capistrano-rvm', require: nil
  gem 'capistrano-rails', require: nil
  gem 'capistrano-bundler', require: nil
  gem 'capistrano-passenger', require: nil
  gem 'capistrano-sidekiq', require: nil
  gem 'capistrano-nvm', require: nil
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
  gem 'redis-rack'
  gem 'rack-cache', require: 'rack/cache'
  
  # PAPERCLIP
  gem 'aws-sdk-s3'
end

group :doc do
  gem 'redcarpet'
  gem 'yard', require: nil
end
