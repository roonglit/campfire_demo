class CreateCampfireMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :campfire_messages do |t|
      t.references :room, null: false, foreign_key: { to_table: :campfire_rooms }
      t.references :creator, null: false, foreign_key: { to_table: :campfire_users }
      t.string :client_message_id, null: false

      t.timestamps
    end
  end
end
