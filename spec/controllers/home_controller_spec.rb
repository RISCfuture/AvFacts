require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    it "should render the index template" do
      get :index
      expect(response.status).to be(200)
      expect(response).to render_template('index')
    end
  end
end
