# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_07_024902) do
  create_table "campfire_memberships", force: :cascade do |t|
    t.datetime "connected_at"
    t.integer "connections", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "involvement", default: "mentions"
    t.integer "room_id", null: false
    t.datetime "unread_at"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["room_id", "created_at"], name: "index_campfire_memberships_on_room_id_and_created_at"
    t.index ["room_id", "user_id"], name: "index_campfire_memberships_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_campfire_memberships_on_room_id"
    t.index ["user_id"], name: "index_campfire_memberships_on_user_id"
  end

  create_table "campfire_rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "creator_id", null: false
    t.string "name"
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_campfire_rooms_on_creator_id"
  end

  create_table "campfire_users", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "bio"
    t.string "bot_token"
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["bot_token"], name: "index_campfire_users_on_bot_token", unique: true
    t.index ["user_id"], name: "index_campfire_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "campfire_memberships", "campfire_rooms", column: "room_id"
  add_foreign_key "campfire_memberships", "campfire_users", column: "user_id"
  add_foreign_key "campfire_rooms", "campfire_users", column: "creator_id"
  add_foreign_key "campfire_users", "users"
end
