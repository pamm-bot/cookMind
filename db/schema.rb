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

ActiveRecord::Schema[8.1].define(version: 2026_06_26_193821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id" ], name: "index_chats_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index [ "chat_id" ], name: "index_messages_on_chat_id"
  end

  create_table "profils", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "dietary_preferences"
    t.json "ingredients"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id" ], name: "index_profils_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "calories"
    t.text "content"
    t.datetime "created_at", null: false
    t.text "ingredients"
    t.string "meal_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id" ], name: "index_recipes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index [ "email" ], name: "index_users_on_email", unique: true
    t.index [ "reset_password_token" ], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "profils", "users"
  add_foreign_key "recipes", "users"
end
