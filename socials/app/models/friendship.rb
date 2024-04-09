# frozen_string_literal: true

# Friendship
class Friendship < ApplicationRecord
  def self.friends?(user_id, friend_id)
    return true if user_id == friend_id

    Friendship
      .exists?(asker_id: user_id, accepter_id: friend_id, accepted: true) ||
      Friendship.exists?(asker_id: friend_id, accepter_id: user_id, accepted: true)
  end

  def self.pending_friendship?(user_id, friend_id)
    Friendship
      .exists?(asker_id: user_id, accepter_id: friend_id, accepted: false)
  end

  def self.accept_friendship(user_id, friend_id)
    Friendship
      .where(asker_id: friend_id, accepter_id: user_id, accepted: false)
      .update(accepted: true)
  end

  def self.create_friendship(user_id, friend_id)
    if pending_friendship?(friend_id, user_id)
      Friendship
        .where(asker_id: friend_id, accepter_id: user_id, accepted: false)
        .update(accepted: true)
    else
      Friendship
        .create(asker_id: user_id, accepter_id: friend_id, accepted: false)
    end
  end

  def self.end_friendship(user_id, friend_id)
    Friendship
      .where(asker_id: user_id, accepter_id: friend_id)
      .or(Friendship.where(asker_id: friend_id, accepter_id: user_id))
      .destroy_all
  end

  def self.friendship_exists?(user_id, friend_id)
    Friendship
      .exists?(asker_id: user_id, accepter_id: friend_id) ||
      Friendship.exists?(asker_id: friend_id, accepter_id: user_id)
  end

  def self.friendship_request_exists?(user_id, friend_id)
    Friendship
      .exists?(asker_id: user_id, accepter_id: friend_id, accepted: false) ||
      Friendship.exists?(asker_id: friend_id, accepter_id: user_id, accepted: false)
  end

  def self.friendship_request(user_id, friend_id)
    Friendship
      .select(:asker_id, :accepter_id, :created_at)
      .where(asker_id: user_id, accepter_id: friend_id, accepted: false)
      .or(Friendship.where(asker_id: friend_id, accepter_id: user_id, accepted: false))
      .first
  end

  def self.friendship(user_id, friend_id)
    Friendship
      .select(:asker_id, :accepter_id, :updated_at)
      .where(asker_id: user_id, accepter_id: friend_id, accepted: true)
      .or(Friendship.where(asker_id: friend_id, accepter_id: user_id, accepted: true))
      .first
  end

  def self.friendships(user_id)
    Friendship
      .select(:asker_id, :accepter_id, :updated_at)
      .where(asker_id: user_id,
             accepted: true)
      .or(Friendship.where(accepter_id: user_id,
                           accepted: true))
      .map do |friendship|
        { friend_id: friendship.asker_id == user_id ? friendship.accepter_id : friendship.asker_id,
          started_at: friendship.updated_at }
      end
  end

  def self.sent_friendship_requests(user_id)
    Friendship
      .select(:accepter_id, :created_at)
      .where(asker_id: user_id, accepted: false)
      .map { |friendship| { friend_id: friendship.accepter_id, sent_at: friendship.created_at } }
  end

  def self.recieved_friendship_requests(user_id)
    Friendship
      .select(:asker_id, :created_at)
      .where(accepter_id: user_id, accepted: false)
      .map { |friendship| { friend_id: friendship.asker_id, recieved_at: friendship.created_at } }
  end
end
