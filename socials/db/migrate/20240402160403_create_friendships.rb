# frozen_string_literal: true

# CreateFriendships
class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.string :asker_id
      t.string :accepter_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
