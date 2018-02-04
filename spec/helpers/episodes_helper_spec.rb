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
end
