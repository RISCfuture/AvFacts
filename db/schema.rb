# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_30_221109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "episodes", force: :cascade do |t|
    t.integer "number", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.string "author"
    t.string "summary"
    t.text "description", null: false
    t.text "script"
    t.datetime "published_at", null: false
    t.boolean "processed", default: false, null: false
    t.boolean "explicit", default: false, null: false
    t.boolean "blocked", default: false, null: false
    t.tsvector "fulltext_search"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "mp3_size"
    t.bigint "aac_size"
    t.text "credits"
    t.index ["fulltext_search"], name: "episodes_fulltext_search", using: :gin
    t.index ["number"], name: "episodes_number_unique", unique: true
    t.index ["published_at", "number"], name: "episodes_index_action"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 50, null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
