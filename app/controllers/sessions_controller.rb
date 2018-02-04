require 'securerandom'

# Semi-RESTful singleton API controller for logging and an out of the app.

class SessionsController < ApplicationController

  # Returns to the front-end information about the current session.
  #
  # Routes
  # ------
  #
  # * `GET /session.json`
  #
  # Response
  # --------
  #
  # Renders a JSON object with the username and token of the current user. These
  # values are `nil` if there is no active session.

  def show
    if (@user = User.find_by_id(session[:user_id]))
      respond_to do |format|
        format.json do
          render json: {
              username: @user.username,
              token:    session[:token]
          }
        end
      end
    else
      render json: {
          username: nil,
          token:    nil
      }
    end
  end

  # Logs a user in from a given username and password.
  #
  # Routes
  # ------
  #
  # * `POST /session.json`
  #
  # Query Parameters
  # ----------------
  #
  # |            |                      |
  # |:-----------|:---------------------|
  # | `username` | The {User} username. |
  # | `password` | The user's password. |
  #
  # Response
  # --------
  #
  # **Successful authentication:** 200 OK and the same response as {#show}.
  #
  # **Invalid credentials:** 401 Unauthorized and empty body.

  def create
    @user = User.find_by_username(params[:username])
    if @user&.authenticate(params[:password])
      @token = log_in(@user)

      respond_to do |format|
        format.json do
          render json: {
              username: @user.username,
              token:    @token
          }
        end
      end
    else
      log_out
      head :unauthorized
    end
  end

  # Logs a user out.
  #
  # Routes
  # ------
  #
  # * `DELETE /session.json`

  def destroy
    log_out
    head :ok
  end

  protected

  # Logs a user in and generates a token.
  #
  # @param [User] user The user to log in.
  # @return [String] The generated token.

  def log_in(user)
    token             = SecureRandom.base58(64)
    session[:user_id] = user.id
    session[:token]   = token
    return token
  end

  # Logs the current user out.

  def log_out
    session[:user_id] = nil
    session[:token]   = nil
  end
end
