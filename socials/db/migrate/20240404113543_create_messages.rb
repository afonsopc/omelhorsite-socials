# frozen_string_literal: true

# CreateMessages
class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :sender_id
      t.string :receiver_id
      t.text :body
      t.string :message_type

      t.timestamps
    end
  end
end
