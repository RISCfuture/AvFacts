json.array!(@episodes) do |episode|
  json.call episode, :number, :title, :subtitle, :summary, :author,
            :description, :published_at, :script?

  json.image do
    json.preview_url url_for(episode.thumbnail_image)
  end if episode.thumbnail_image&.processed?

  json.audio do
    json.duration episode.audio.metadata[:duration]

    json.mp3 do
      json.url episode.mp3.public_cdn_url
      json.content_type episode.mp3.content_type
      json.byte_size episode.mp3_size
    end

    json.aac do
      json.url episode.aac.public_cdn_url
      json.content_type episode.aac.content_type
      json.byte_size episode.aac_size
    end
  end if episode.processed?
end
