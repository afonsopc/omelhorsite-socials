# frozen_string_literal: true

# SettingsController
class SettingsController < ApplicationController
  def show
    validation_status = validate_show_settings_request
    return head validation_status unless validation_status == :ok

    render json: {
      settings: user_settings
    }
  end

  def update
    validation_status = validate_update_settings_request
    return head validation_status unless validation_status == :ok

    settings_params = { allow_friend_requests: params[:allow_friend_requests],
                        allow_non_friend_messages: params[:allow_non_friend_messages] }
    Settings.update_settings(user_id, settings_params)

    head :ok
  end

  private

  def validate_show_settings_request
    return :not_found if user_id.nil?

    :ok
  end

  def validate_update_settings_request
    return :bad_request if params[:allow_friend_requests].nil? ||
                           params[:allow_non_friend_messages].nil? ||
                           ![true, false].include?(params[:allow_friend_requests]) ||
                           ![true, false].include?(params[:allow_non_friend_messages])

    validate_show_settings_request
  end
end
