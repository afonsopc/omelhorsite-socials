# frozen_string_literal: true

# FriendshipsController
class FriendshipsController < ApplicationController
  def show
    validation_status = validate_show_friendships_request
    return head validation_status unless validation_status == :ok

    render json: { friendships: Friendship.friendships(user_id),
                   sent_friendship_requests: Friendship.sent_friendship_requests(user_id),
                   recieved_friendship_requests: Friendship.recieved_friendship_requests(user_id) }
  end

  def create
    validation_status = validate_create_friendship_request
    return head validation_status unless validation_status == :ok

    Friendship.create_friendship(user_id, friend_id)
    NotificationsApi.new.friendship_request(friend_id, user_id)

    head :created
  end

  def accept
    validation_status = validate_accept_friendship_request
    return head validation_status unless validation_status == :ok

    Friendship.accept_friendship(user_id, friend_id)
    NotificationsApi.new.friendship_accepted(friend_id, user_id)

    head :ok
  end

  def end
    validation_status = validate_end_friendship_request
    return head validation_status unless validation_status == :ok

    Friendship.end_friendship(user_id, friend_id)

    head :ok
  end

  private

  def validate_user_id_and_friend_id
    return :not_found if user_id.nil? || friend_id.nil?

    :ok
  end

  def validate_show_friendships_request
    return :not_found if user_id.nil?

    :ok
  end

  def validate_end_friendship_request
    validation_status = validate_user_id_and_friend_id

    return validation_status unless validation_status == :ok

    return :not_found unless Friendship.friends?(user_id, friend_id) ||
                             Friendship.pending_friendship?(user_id, friend_id) ||
                             Friendship.pending_friendship?(friend_id, user_id)

    :ok
  end

  def validate_accept_friendship_request
    validation_status = validate_user_id_and_friend_id

    return validation_status unless validation_status == :ok

    return :not_found if Friendship.friends?(user_id, friend_id)

    :ok
  end

  def validate_create_friendship_request
    validation_status = validate_user_id_and_friend_id

    return validation_status unless validation_status == :ok

    return :unauthorized if !Settings.user_settings(friend_id)['allow_friend_requests'] ||
                            Block.blocked?(friend_id, user_id)

    return :conflict if Friendship.friends?(user_id, friend_id) ||
                        Friendship.pending_friendship?(user_id, friend_id)

    :ok
  end
end
