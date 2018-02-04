require 'rails_helper'
require 'securerandom'

RSpec.describe SessionsController, type: :controller do
  render_views

  describe '#show' do
    before :each do
      @user  = FactoryBot.create(:user)
      @token = SecureRandom.base58(64)
    end

    it "should return information on the current session" do
      session[:user_id] = @user.id
      session[:token]   = @token

      get :show, params: {format: 'json'}
      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).
          to eql('username' => @user.username,
                 'token'    => @token)
    end

    it "should return empty JSON if there is no session" do
      get :show, params: {format: 'json'}
      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).
          to eql('username' => nil,
                 'token'    => nil)
    end
  end

  describe '#create' do
    before :each do
      @password = SecureRandom.base58
      @user     = FactoryBot.create(:user, password: @password)
    end

    it "should log a user in and set the token" do
      post :create, params: {username: @user.username, password: @password, format: 'json'}
      expect(response.status).to eql(200)
      json = JSON.parse(response.body)
      expect(json['username']).to eql(@user.username)
      expect(json['token']).not_to be_nil
    end

    it "should 401 if the username is incorrect" do
      post :create, params: {username: 'not-found', password: @password, format: 'json'}
      expect(response.status).to eql(401)
    end

    it "should 401 if the password is incorrect" do
      post :create, params: {username: @user.username, password: 'incorrect', format: 'json'}
      expect(response.status).to eql(401)
    end
  end

  describe '#destroy' do
    it "should clear the session variables" do
      session[:user_id] = FactoryBot.create(:user).id
      session[:token] = 'token123'

      delete :destroy, params: {format: 'json'}
      expect(response.status).to eql(200)
      expect(session[:user_id]).to be_nil
      expect(session[:token]).to be_nil
    end
  end
end
