# frozen_string_literal: true

# MessagesController
class MessagesController < ApplicationController
  def conversations
    validation_status = validate_conversations_request
    return head validation_status unless validation_status == :ok

    render json: { conversations: Message.conversations(user_id) }
  end

  def send_text_message
    validation_status = validate_send_text_message_request
    return head validation_status unless validation_status == :ok

    Message.send_text_message(user_id, receiver_id, params[:body])
    NotificationsApi.new.message_received(receiver_id, user_id)

    head :created
  end

  def send_image_message
    validation_status = validate_send_image_message_request
    return head validation_status unless validation_status == :ok

    Message.send_image_message(user_id, receiver_id, image_binary_data)
    NotificationsApi.new.message_received(receiver_id, user_id)

    head :created
  end

  def conversation
    validation_status = validate_conversation_request
    return head validation_status unless validation_status == :ok

    render json: { messages: Message.conversation(user_id, receiver_id, params[:page]) }
  end

  def delete_conversation
    validation_status = validate_delete_conversation_request
    return head validation_status unless validation_status == :ok

    Message.delete_conversation(user_id, receiver_id)

    head :ok
  end

  private

  def send_message_validation
    validation_status = validate_delete_conversation_request

    return validation_status unless validation_status == :ok
    return :forbidden if Block.blocked?(user_id, receiver_id) || Block.blocked?(receiver_id, user_id)
    return :unauthorized unless Settings.user_settings(friend_id)['allow_non_friend_messages'] ||
                                Friendship.friends?(user_id, receiver_id)

    :ok
  end

  def validate_conversations_request
    return :not_found if user_id.nil?

    :ok
  end

  def validate_delete_conversation_request
    validation_status = validate_conversations_request

    return validation_status unless validation_status == :ok
    return :bad_request if receiver_id.nil?

    :ok
  end

  def validate_conversation_request
    validation_status = validate_conversations_request

    return validation_status unless validation_status == :ok

    return :bad_request if params[:page].nil? ||
                           params[:page].to_i.negative?

    :ok
  end

  def validate_send_text_message_request
    validation_status = send_message_validation

    return validation_status unless validation_status == :ok
    return :bad_request if params[:body].nil? ||
                           params[:body].empty? ||
                           params[:body].length > 255

    :ok
  end

  def validate_send_image_message_request
    validation_status = send_message_validation

    return validation_status unless validation_status == :ok
    return :bad_request if image_binary_data.nil?

    :ok
  end
end
