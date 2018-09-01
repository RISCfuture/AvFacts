require 'rails_helper'

RSpec.describe Episode, type: :model do
  context 'number' do
    it "should start at 1" do
      Episode.destroy_all
      expect(FactoryBot.create(:episode).number).to be(1)
    end

    it "should increment" do
      Episode.destroy_all
      FactoryBot.create :episode, number: 3
      expect(FactoryBot.create(:episode).number).to be(4)
    end
  end

  context 'published_at' do
    it "should default to the current time" do
      expect(FactoryBot.create(:episode, published_at: nil).published_at).to eql(Time.current)
    end
  end

  describe '#published?' do
    it "should return true for a published episode" do
      expect(FactoryBot.create(:episode, published_at: 1.day.ago)).to be_published
    end

    it "should return false for an unpublished episode" do
      expect(FactoryBot.create(:episode, published_at: 1.day.from_now)).not_to be_published
    end
  end

  describe '#mp3' do
    it "should return the MP3 Transcode" do
      episode = FactoryBot.create(:episode)
      expect(episode.mp3).to be_kind_of(Transcode)
      expect(episode.mp3.blob).to eql(episode.audio.blob)
      expect(episode.mp3.encoding.format).to eql('mp3')
    end

    it "should return nil if the audio hasn't been added yet" do
      episode = FactoryBot.create(:episode, audio: nil)
      expect(episode.mp3).to be_nil
    end
  end

  describe '#aac' do
    it "should return the AAC Transcode" do
      episode = FactoryBot.create(:episode)
      expect(episode.aac).to be_kind_of(Transcode)
      expect(episode.aac.blob).to eql(episode.audio.blob)
      expect(episode.aac.encoding.format).to eql('aac')
    end

    it "should return nil if the audio hasn't been added yet" do
      episode = FactoryBot.create(:episode, audio: nil)
      expect(episode.aac).to be_nil
    end
  end

  describe '#thumbnail_image' do
    it "should return the thumbnail image" do
      episode = FactoryBot.create(:episode)
      episode.image.analyze
      expect(episode.thumbnail_image).to be_kind_of(ActiveStorage::Variant)
      expect(episode.thumbnail_image.blob).to eql(episode.image.blob)
      expect(episode.thumbnail_image.variation.transformations).to eql(thumbnail: '200x200', crop: '200x200+0+0')
    end

    it "should return nil if the image is nil" do
      episode = FactoryBot.create(:episode, image: nil)
      expect(episode.thumbnail_image).to be_nil
    end

    it "should return nil if the image is not yet analyzed" do
      episode = FactoryBot.create(:episode)
      expect(episode.thumbnail_image).to be_nil
    end
  end

  describe '#preprocess!' do
    it "should preprocess the episode and image data" do
      episode = FactoryBot.create(:episode)
      episode.preprocess!
      episode.reload
      expect(episode.mp3).to be_processed
      expect(episode.aac).to be_processed
      expect(episode.thumbnail_image.send(:processed?)).to be(true)
      expect(episode.mp3_size).to be(33_271)
      expect(episode.aac_size).to be(22_088)
    end

    it "should set processed and advance published_at if the episode is ready" do
      episode = FactoryBot.create(:episode, published_at: 1.day.ago)
      episode.preprocess!
      expect(episode).to be_processed
      expect(episode.published_at).to eql(Time.current)
    end

    it "should not change processed or published_at if the episode is not yet ready" do
      episode = FactoryBot.create(:episode, published_at: 1.day.ago, audio: nil)
      episode.preprocess!
      expect(episode).not_to be_processed
      expect(episode.published_at).to eql(1.day.ago)
    end

    it "should not change published_at if the episode is to be published in the future" do
      episode = FactoryBot.create(:episode, published_at: 1.day.from_now)
      episode.preprocess!
      expect(episode).to be_processed
      expect(episode.published_at).to eql(1.day.from_now)
    end
  end

  describe '[hooks]' do
    it "should preprocess the episode and image data" do
      pending "Does not work inside of transactionalized tests"
      episode = FactoryBot.create(:episode)
      expect(episode.mp3).to be_processed
      expect(episode.aac).to be_processed
      expect(episode.thumbnail_image.send(:processed?)).to be(true)
    end
  end
end
