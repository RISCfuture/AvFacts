require 'rails_helper'

RSpec.describe EpisodesHelper, type: :helper do
  describe '#channel' do
    it "should load the config/channel.yml file as a struct" do
      expect(helper.channel.title).to eql("AvFacts - Aviation knowledge without limits")
      expect(helper.channel.owner.name).to eql("Tim Morgan")
    end
  end

  describe '#publication_date' do
    it "should return the date of the most recently published episode" do
      FactoryBot.create :episode, processed: true, published_at: 1.day.ago
      FactoryBot.create :episode, processed: true, published_at: 5.minutes.ago, blocked: true # blocked episodes can be included
      FactoryBot.create :episode, processed: true, published_at: 2.days.from_now

      expect(helper.publication_date).to eql(5.minutes.ago)
    end
  end

  describe '#full_title' do
    it "should return the number and title" do
      episode = FactoryBot.create(:episode, number: 2141, title: "A thing")
      expect(helper.full_title(episode)).to eql("#2,141: A thing")
    end
  end

  describe '#duration_string' do
    it "should convert a duration in seconds to a string" do
      expect(helper.duration_string(40)).to eql("0:00:40")
      expect(helper.duration_string(140)).to eql("0:02:20")
      expect(helper.duration_string(14000)).to eql("3:53:20")
    end
  end

  describe '#category_tags' do
    before(:each) { @xml = Builder::XmlMarkup.new }

    it "should render a single category" do
      helper.category_tags @xml, "A Category"
      expect(@xml.target!).to eql(<<~XML.gsub(/\s*\n\s*/, ''))
        <itunes:category text="A Category"/>
      XML
    end

    it "should render multiple categories" do
      helper.category_tags @xml, %w[c1 c2]
      expect(@xml.target!).to eql(<<~XML.gsub(/\s*\n\s*/, ''))
        <itunes:category text="c1"/>
        <itunes:category text="c2"/>
      XML
    end

    it "should render categories and subcategories" do
      helper.category_tags @xml, 'c1' => 'sc1', 'c2' => 'sc2'
      expect(@xml.target!).to eql(<<~XML.gsub(/\s*\n\s*/, ''))
        <itunes:category text="c1">
          <itunes:category text="sc1"/>
        </itunes:category>
        <itunes:category text="c2">
          <itunes:category text="sc2"/>
        </itunes:category>
      XML
    end

    it "should render categories with multiple subcategories" do
      helper.category_tags @xml, 'c1' => 'sc1', 'c2' => %w[sc2 sc3]
      expect(@xml.target!).to eql(<<~XML.gsub(/\s*\n\s*/, ''))
        <itunes:category text="c1">
          <itunes:category text="sc1"/>
        </itunes:category>
        <itunes:category text="c2">
          <itunes:category text="sc2"/>
          <itunes:category text="sc3"/>
        </itunes:category>
      XML
    end
  end
end
