json.call @episode, :id, :number, :title, :subtitle, :summary, :author,
          :description, :published_at, :explicit, :blocked, :credits

json.script(@episode.script) if admin?

json.image do
  json.preview_url url_for(@episode.thumbnail_image)
  json.width @episode.image.metadata['width']
  json.height @episode.image.metadata['height']
  json.size @episode.image.byte_size
end if @episode.thumbnail_image&.send(:processed?)

json.audio do
  json.duration @episode.audio.metadata['duration']
  json.size @episode.audio.byte_size

  json.mp3 do
    json.url @episode.mp3.public_cdn_url
    json.content_type @episode.mp3.content_type
    json.byte_size @episode.mp3_size
  end

  json.aac do
    json.url @episode.aac.public_cdn_url
    json.content_type @episode.aac.content_type
    json.byte_size @episode.aac_size
  end
end if @episode.processed?
