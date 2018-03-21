require 'rails_helper'
require 'transcode'

RSpec.describe TranscodingController, type: :controller do
  include Rails.application.routes.url_helpers
  describe '#show' do
    before :each do
      @episode = FactoryBot.create(:episode)
    end

    it "should redirect to the service URL for a transcoded file" do
      signed_path = polymorphic_url(@episode.audio.transcode('mp3', %w[-ac 1]), host: 'test.host')
      parts = signed_path.split('/')
      get :show, params: {signed_blob_id: parts[6], encoding_key: parts[7], filename: parts[8]}
      expect(response.headers['Location']).to match(/http:\/\/test\.host\/rails\/active_storage\/disk\/.+\/audio\.mp3\?content_type=audio%2Fmpeg&disposition=inline%3B\+filename%3D%22audio\.mp3%22%3B\+filename%2A%3DUTF-8%27%27audio\.mp3$/)
    end

    it "should render a 404 for an unknown blob" do
      pending "find_signed apparently raises RecordNotFound instead of returning nil"
      blob = ActiveStorage.verifier.generate('hello', purpose: :blob_id)
      get :show, params: {signed_blob_id: blob, encoding_key: 'world', filename: 'foo.txt'}
      expect(response.status).to eql(404)
    end
  end
end
