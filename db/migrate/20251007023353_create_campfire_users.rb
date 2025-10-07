class CreateCampfireUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :campfire_users do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :role, default: 0, null: false
      t.boolean :active, default: true
      t.text :bio
      t.string :bot_token

      t.timestamps
    end

    add_index :campfire_users, :bot_token, unique: true
  end
end
