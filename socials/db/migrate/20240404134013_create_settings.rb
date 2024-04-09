# frozen_string_literal: true

# CreateSettings
class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :user_id
      t.boolean :allow_friend_requests, default: true
      t.boolean :allow_non_friend_messages, default: true

      t.timestamps
    end
  end
end
