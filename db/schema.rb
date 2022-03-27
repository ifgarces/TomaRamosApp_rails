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

ActiveRecord::Schema[7.0].define(version: 2022_03_27_014311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_metadata", force: :cascade do |t|
    t.string "latest_version_name", limit: 100
    t.string "catalog_current_period"
    t.string "catalog_last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ramo_event_types", force: :cascade do |t|
    t.string "name", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ramo_events", force: :cascade do |t|
    t.string "location", limit: 30
    t.string "day_of_week", limit: 30
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
    t.string "materia", limit: 30
    t.integer "curso"
    t.string "seccion", limit: 30
    t.string "plan_estudios", limit: 30
    t.string "conect_liga", limit: 30
    t.string "lista_cruzada", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "tag", limit: 30
    t.string "password_digest"
    t.string "first_name", limit: 100
    t.string "last_name", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag"], name: "index_users_on_tag", unique: true
  end

end
