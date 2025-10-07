class CreateCampfireRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :campfire_rooms do |t|
      t.string :name
      t.string :type, null: false
      t.references :creator, foreign_key: { to_table: :campfire_users }, null: false

      t.timestamps
    end
  end
end
