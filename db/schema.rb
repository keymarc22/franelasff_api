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

ActiveRecord::Schema.define(version: 2022_03_22_000018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "catalogue_shirts", force: :cascade do |t|
    t.bigint "shirt_id", null: false
    t.bigint "catalogue_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_catalogue_shirts_on_catalogue_id"
    t.index ["shirt_id"], name: "index_catalogue_shirts_on_shirt_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_catalogues_on_user_id"
  end

  create_table "shirts", force: :cascade do |t|
    t.string "code"
    t.string "color"
    t.string "print"
    t.integer "quantity"
    t.text "aditional_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.string "size"
    t.bigint "user_id"
    t.index ["code"], name: "index_shirts_on_code", unique: true
    t.index ["store_id"], name: "index_shirts_on_store_id"
    t.index ["user_id"], name: "index_shirts_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "auth_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "catalogue_shirts", "catalogues"
  add_foreign_key "catalogue_shirts", "shirts"
end
