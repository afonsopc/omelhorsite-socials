# frozen_string_literal: true

# Block
class Block < ApplicationRecord
  def self.block_user(user_id, friend_id)
    return if user_id.nil? || friend_id.nil?

    Block.create(blocker_id: user_id, blocked_id: friend_id)
  end

  def self.unblock_user(user_id, friend_id)
    return if user_id.nil? || friend_id.nil?

    Block
      .where(blocker_id: user_id, blocked_id: friend_id)
      .destroy_all
  end

  def self.blocked?(user_id, friend_id)
    return false if user_id.nil? || friend_id.nil?

    Block
      .where(blocker_id: user_id, blocked_id: friend_id)
      .exists?
  end

  def self.blocked_users(user_id)
    return [] if user_id.nil?

    Block
      .where(blocker_id: user_id)
      .pluck(:blocked_id)
  end
end
