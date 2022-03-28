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

ActiveRecord::Schema[7.0].define(version: 2022_03_27_153807) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "app_metadata", force: :cascade do |t|
    t.string "latest_version_name", limit: 100
    t.string "catalog_current_period"
    t.string "catalog_last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "career_advices", force: :cascade do |t|
    t.string "title", limit: 60
    t.text "description"
    t.string "url", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quick_hyperlinks", force: :cascade do |t|
    t.string "name", limit: 60
    t.string "url", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ramo_event_types", force: :cascade do |t|
    t.string "name", limit: 60
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ramo_events", force: :cascade do |t|
    t.string "location", limit: 60
    t.string "day_of_week", limit: 60
    t.time "start_time"
    t.time "end_time"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ramos", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "profesor", limit: 100
    t.integer "creditos"
    t.string "materia", limit: 60
    t.integer "curso"
    t.string "seccion", limit: 60
    t.string "plan_estudios", limit: 60
    t.string "conect_liga", limit: 60
    t.string "lista_cruzada", limit: 60
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "tag", limit: 60
    t.string "password_digest"
    t.string "first_name", limit: 100
    t.string "last_name", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag"], name: "index_users_on_tag", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
