json.array!(@episodes) do |episode|
  json.call episode, :number, :title, :subtitle, :summary, :author,
            :description, :published_at, :script?
  json.duration(episode.audio.metadata[:duration]) if episode.processed?

  json.image do
    json.preview_url url_for(episode.thumbnail_image)
  end if episode.thumbnail_image && episode.thumbnail_image.send(:processed?)

  json.audio do
    json.mp3 do
      json.url url_for(episode.mp3)
      json.content_type episode.mp3.content_type
      json.byte_size episode.mp3.byte_size
    end if episode.processed?

    json.aac do
      json.url url_for(episode.aac)
      json.content_type episode.aac.content_type
      json.byte_size episode.aac.byte_size
    end if episode.processed?
  end
end
