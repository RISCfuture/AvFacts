require 'open-uri'
require 'time'
require 'open3'

io  = open('http://feeds.soundcloud.com/users/soundcloud:users:326017181/sounds.rss')
rss = Nokogiri::XML(io)
io.close

assets = Pathname.new('/Volumes/Mac Software/AvFacts')

rss.xpath('/rss/channel/item').reverse_each do |item|
  matches = item.xpath('title').first.content.match(/^AvFacts #(\d+)(?::| -) (.+)$/)
  number  = matches[1].to_i
  title   = matches[2]
  date    = Time.zone.parse(item.xpath('pubDate').first.content)

  puts "##{number}: #{title}"

  asset_dir = assets.children.detect { |a| a.basename.to_s.start_with?("#{number} -") }

  if (script_file = asset_dir.join('Script.rtf')).exist?
    script_html, = Open3.capture2('textutil', '-convert', 'html', '-stdout', script_file.to_s)
    script_md,   = Open3.capture2('pandoc', '--from=html', '--to=markdown', stdin_data: script_html)
  end

  if script_md
    script_md = script_md.each_line.map(&:strip).join("\n")
    script_md.gsub!(/\[.+\]\{\.Apple-converted-space\}/m, ' ')
    while script_md.gsub!(/\[(.*?)\]\{.\w+?\}/m, "\\1")
      # do the thing
    end
    script_md.gsub!(/^\s*\\\s*$/, '')
    script_md.gsub!(/\n{3,}/m, "\n\n")
    script_md.chomp!
  end

  episode = Episode.new(number:       number,
                        title:        title,
                        created_at:   date,
                        published_at: date,
                        description:  item.xpath('description').first.content,
                        script:       script_md)

  episode.audio.attach io:           asset_dir.join('Final Mix.aif').open,
                       content_type: 'audio/aiff',
                       filename:     'Final Mix.aif'

  if (artwork = asset_dir.join('Artwork.png')).exist?
    episode.image.attach io:           artwork.open,
                         content_type: 'image/png',
                         filename:     'Artwork.png'
  else
    artwork_url = item.xpath('itunes:image').first.attributes['href'].content
    episode.image.attach io:           URI.parse(artwork_url).open,
                         content_type: 'image/jpeg',
                         filename:     File.basename(artwork_url)
  end

  episode.save!
end
