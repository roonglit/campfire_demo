class CreateCampfireMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :campfire_memberships do |t|
      t.references :room, null: false, foreign_key: { to_table: :campfire_rooms }
      t.references :user, null: false, foreign_key: { to_table: :campfire_users }
      t.string :involvement, default: "mentions"
      t.integer :connections, default: 0, null: false
      t.datetime :unread_at
      t.datetime :connected_at

      t.timestamps
    end

    add_index :campfire_memberships, [:room_id, :user_id], unique: true
    add_index :campfire_memberships, [:room_id, :created_at]
  end
end
