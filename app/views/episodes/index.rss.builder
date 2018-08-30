xml.rss('xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
        'xmlns:atom'   => 'http://www.w3.org/2005/Atom',
        version:       '2.0') do

  xml.channel do
    xml.atom :link, href: episodes_url(format: 'rss'), rel: 'self', type: 'application/rss+xml'
    unless @last_page
      xml.atom :link, href: episodes_url(before: @episodes.last.number, format: 'rss'), rel: 'next', type: 'application/rss+xml'
    end
    xml.link root_url

    xml.title channel.title
    xml.description channel.description
    xml.itunes :summary, channel.summary
    xml.itunes :subtitle, channel.subtitle

    xml.itunes :owner do
      xml.itunes :name, channel.owner.name
      xml.itunes :email, channel.owner.email
    end
    xml.itunes :author, channel.author

    xml.pubDate publication_date.rfc822
    xml.lastBuildDate publication_date.rfc822
    xml.ttl 60

    xml.language channel.language
    xml.copyright channel.copyright
    xml.webMaster channel.webmaster
    xml.itunes :explicit, (channel.explicit ? 'yes' : 'no')
    category_tags(xml, channel.itunes_category)

    xml.itunes :image, href: asset_pack_url('packs/logo.png')
    xml.image do
      xml.url asset_pack_url('packs/logo.png')
      xml.title channel.title
      xml.link root_url
    end

    @episodes.each do |episode|
      xml.item do
        xml.guid "guid://avfacts.org/Episode/#{episode.id}"
        xml.link episode_url(episode)
        xml.pubDate episode.published_at.rfc822

        xml.title full_title(episode)
        xml.itunes :title, episode.title
        xml.itunes(:subtitle, episode.subtitle) if episode.subtitle?
        xml.itunes :author, (episode.author || channel.author)
        xml.itunes :summary, (episode.summary || truncate(episode.description, length: 100, omission: "…"))
        xml.description full_description(episode)

        xml.enclosure url: episode_url(episode, format: :mp3), type: episode.mp3.content_type, length: episode.mp3_size
        xml.enclosure url: episode_url(episode, format: :aac), type: episode.aac.content_type, length: episode.aac_size

        xml.itunes :image, href: polymorphic_url(episode.itunes_image, only_path: false)
        if episode.audio.metadata[:duration]
          xml.itunes :duration, duration_string(episode.audio.metadata[:duration])
        end

        xml.itunes :order, episode.number
        xml.itunes :explicit, (episode.explicit? ? 'yes' : 'no')
        xml.itunes :block, (episode.blocked? ? 'yes' : 'no')
      end
    end
  end
end
