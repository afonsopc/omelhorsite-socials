# frozen_string_literal: true

# Message
class Message < ApplicationRecord
  def self.conversations(user_id)
    sent_messages = Message.where(sender_id: user_id).distinct.pluck(:receiver_id)
    received_messages = Message.where(receiver_id: user_id).distinct.pluck(:sender_id)

    sent_messages | received_messages
  end

  def self.conversation(user_id, other_user_id, page)
    Message
      .select(:id, :sender_id, :body, :message_type, :created_at)
      .where(sender_id: user_id, receiver_id: other_user_id)
      .or(Message.where(sender_id: other_user_id, receiver_id: user_id))
      .order(created_at: :desc)
      .paginate(page: page, per_page: 10)
  end

  def self.delete_conversation(user_id, other_user_id)
    Message
      .where(sender_id: user_id, receiver_id: other_user_id)
      .or(Message.where(sender_id: other_user_id, receiver_id: user_id))
      .destroy_all
  end

  def self.send_text_message(sender_id, receiver_id, body)
    Message
      .create(
        sender_id: sender_id,
        receiver_id: receiver_id,
        body: body,
        message_type: 'text'
      )
  end

  def self.send_image_message(sender_id, receiver_id, image)
    Message
      .create(
        sender_id: sender_id,
        receiver_id: receiver_id,
        body: get_url_for_image(image, image.original_filename, image.content_type),
        message_type: 'image'
      )
  end

  def self.get_url_for_image(image, filename, content_type)
    Rails.application.routes.url_helpers.rails_blob_path(
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Message.optimize_image(image).path),
        filename: filename,
        content_type: content_type
      ), only_path: true
    )
  end

  def self.optimize_image(image)
    ImageOptimization
      .new(image)
      .max_dimention(1000)
      .format('webp')
      .quality(75)
      .call
  end
end
