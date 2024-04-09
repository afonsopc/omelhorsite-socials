# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  def user_id
    @user_id ||= begin
      accounts_api = AccountsApi.new
      accounts_api.auth_token_from_headers(request.headers)
      accounts_api.user_id
    end

    @user_id
  end

  def friend_id
    @friend_id ||= begin
      friend_id = params[:friend_id]
      accounts_api = AccountsApi.new
      friend_exists = accounts_api.user_id_exists?(friend_id)

      return if friend_id.nil? || friend_id.empty? || !friend_exists

      friend_id
    end
  end

  def receiver_id
    @receiver_id ||= begin
      receiver_id = params[:receiver_id]
      accounts_api = AccountsApi.new
      receiver_exists = accounts_api.user_id_exists?(receiver_id)

      return if receiver_id.nil? || receiver_id.empty? || !receiver_exists

      receiver_id
    end
  end

  def image_binary_data
    @image_binary_data ||= begin
      image_binary_data = params[:image]

      print "image_binary_data: #{image_binary_data}\n"
      return if image_binary_data.nil?

      image_binary_data
    end
  end

  def user_settings
    @user_settings ||= Settings.user_settings(user_id)
  end
end
