# frozen_string_literal: true

require 'net/http'
require 'uri'

# NotificationsApi
class NotificationsApi < ApplicationApi
  def message_received(receiver_id, sender_id)
    notify(receiver_id, 'message_received', { "sender_id": sender_id })
  end

  def friendship_request(accepter_id, asker_id)
    notify(accepter_id, 'friendship_request', { "asker_id": asker_id })
  end

  def friendship_accepted(asker_id, accepter_id)
    notify(asker_id, 'friendship_accepted', { "accepter_id": accepter_id })
  end

  def notify(user_id, type, context)
    Rails.logger.info("Sending notification to user #{user_id} with type #{type} and context #{context}")

    request = send_request(
      "#{ENV['NOTIFICATIONS_SERVICE_URL']}/notifications.php",
      :post,
      ENV['NOTIFICATIONS_API_KEY'],
      { user_id:, type:, context: },
      ''
    )

    return if request.nil?

    request.code == '200'
  end
end
