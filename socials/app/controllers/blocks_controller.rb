# frozen_string_literal: true

# BlocksController
class BlocksController < ApplicationController
  def show
    validation_status = validate_show_blocks_request
    return head validation_status unless validation_status == :ok

    render json: { blocked_users: Block.blocked_users(user_id) }
  end

  def block
    validation_status = validate_block_request
    return head validation_status unless validation_status == :ok

    Block.block_user(user_id, friend_id)

    head :created
  end

  def unblock
    validation_status = validate_unblock_request
    return head validation_status unless validation_status == :ok

    Block.unblock_user(user_id, friend_id)

    head :ok
  end

  private

  def validate_show_blocks_request
    :not_found if user_id.nil?

    :ok
  end

  def validate_unblock_request
    validation_status = validate_show_blocks_request

    return validation_status unless validation_status == :ok
    return :bad_request if friend_id.nil?
    return :not_found unless Block.blocked?(user_id, friend_id)

    :ok
  end

  def validate_block_request
    validation_status = validate_show_blocks_request

    return validation_status unless validation_status == :ok
    return :bad_request if friend_id.nil?
    return :conflict if Block.blocked?(user_id, friend_id)

    :ok
  end
end
