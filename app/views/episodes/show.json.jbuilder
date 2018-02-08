json.call @episode, :id, :number, :title, :subtitle, :summary, :author,
          :description, :script, :published_at, :explicit, :blocked

json.audio do
  json.duration @episode.audio.metadata['duration']
  json.size @episode.audio.byte_size
end if @episode.processed?

json.image do
  json.width @episode.image.metadata['width']
  json.height @episode.image.metadata['height']
  json.size @episode.image.byte_size
end if @episode.processed?
