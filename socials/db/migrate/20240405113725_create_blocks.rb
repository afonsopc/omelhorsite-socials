# frozen_string_literal: true

# CreateBlocks
class CreateBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :blocks do |t|
      t.string :blocker_id
      t.string :blocked_id

      t.timestamps
    end
  end
end
