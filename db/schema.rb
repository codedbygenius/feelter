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

ActiveRecord::Schema[8.0].define(version: 2025_12_28_160853) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contents", force: :cascade do |t|
    t.integer "content_type"
    t.string "title"
    t.string "url"
    t.text "blog"
    t.bigint "category_id", null: false
    t.bigint "mood_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_contents_on_category_id"
    t.index ["mood_id"], name: "index_contents_on_mood_id"
  end

  create_table "interactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mood_id", null: false
    t.bigint "category_id", null: false
    t.integer "content_type"
    t.datetime "timestamp"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_interactions_on_category_id"
    t.index ["mood_id"], name: "index_interactions_on_mood_id"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mood_id", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mood_id"], name: "index_journal_entries_on_mood_id"
    t.index ["user_id"], name: "index_journal_entries_on_user_id"
  end

  create_table "moods", force: :cascade do |t|
    t.integer "feeling"
    t.bigint "user_id", null: false
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_moods_on_category_id"
    t.index ["user_id"], name: "index_moods_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "user_question"
    t.text "ai_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contents", "categories"
  add_foreign_key "contents", "moods"
  add_foreign_key "interactions", "categories"
  add_foreign_key "interactions", "moods"
  add_foreign_key "interactions", "users"
  add_foreign_key "journal_entries", "moods"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "moods", "categories"
  add_foreign_key "moods", "users"
  add_foreign_key "questions", "users"
end
