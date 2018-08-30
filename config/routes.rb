Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/rails/active_storage/transcoded/:signed_blob_id/:encoding_key/*filename' =>
          'transcoding#show',
      as:                                                                        :rails_blob_transcoding,
      internal:                                                                  true

  direct :rails_transcoding do |transcoder, options|
    signed_blob_id = transcoder.blob.signed_id
    encoding_key   = transcoder.encoding.key
    filename       = transcoder.filename

    route_for(:rails_blob_transcoding, signed_blob_id, encoding_key, filename, options)
  end

  resolve('Transcode') { |transcode, options| route_for(:rails_transcoding, transcode, options) }

  if Rails.env.development?
    require 'sidekiq/web'
    Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
    mount Sidekiq::Web => '/sidekiq'
  end

  # back-end routes handled by rails
  constraints(->(req) { req.format != '*/*' && !req.format.html? }) do
    resources :episodes, only: %i[index show create update destroy]
    resource :session, only: %i[show create destroy]
  end

  # front-end routes handled by Vue-Router (routes.js)
  constraints(->(req) { req.format == '*/*' || req.format.html? }) do #TODO .all? doesn't work here
    root 'home#index'
    get 'upload' => 'home#index'
    get 'episodes/:id' => 'home#index'
    get 'episodes/:id/edit' => 'home#index'
    get 'episodes/:id/script' => 'home#index'
    get 'episodes/:id/:slug' => 'home#index'
    get 'about' => 'home#index'
  end
end
