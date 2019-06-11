require File.expand_path('./environment', __dir__)

# config valid for current version and patch releases of Capistrano
lock '~> 3'

set :application, 'avfacts'
set :repo_url, 'https://github.com/RISCfuture/AvFacts.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :pty,  false

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/www.avfacts.org'

append :linked_files, 'config/master.key', 'config/sidekiq.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'node_modules', 'public/packs', 'public/assets'

set :rvm_ruby_version, "2.6.3@#{fetch :application}"

set :sidekiq_config, 'config/sidekiq.yml'

# set :nvm_type, :system
# set :nvm_node, 'v9.5.0'
# append :nvm_map_bins, 'yarnpkg', './bin/yarn', 'webpack'
set :default_env,
    'PATH' => '/usr/local/nvm/versions/node/v12.4.0/bin:$PATH'

set :bugsnag_api_key, Rails.application.credentials.bugsnag_api_key

set :passenger_restart_with_sudo, true
