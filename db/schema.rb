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

ActiveRecord::Schema.define(version: 2022_08_29_014349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_games", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.float "game_array", null: false, array: true
    t.integer "turn", default: 1
    t.string "url_param"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bot_id"], name: "index_active_games_on_bot_id"
  end

  create_table "bots", force: :cascade do |t|
    t.string "name"
    t.boolean "static"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "evolution_count", default: 0, null: false
    t.bigint "parent_bot"
    t.index ["game_id"], name: "index_bots_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfer_layers", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.float "layer_matrix", null: false, array: true
    t.integer "depth", null: false
    t.integer "row_count", null: false
    t.integer "col_count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bot_id"], name: "index_transfer_layers_on_bot_id"
  end

  add_foreign_key "transfer_layers", "bots", on_delete: :cascade
end
