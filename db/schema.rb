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

ActiveRecord::Schema.define(version: 2022_01_07_052204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.string "name"
    t.boolean "static"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_bots_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfer_edges", force: :cascade do |t|
    t.bigint "upstream_node_id"
    t.bigint "downstream_node_id"
    t.float "weight", default: 0.0
    t.index ["downstream_node_id"], name: "index_transfer_edges_on_downstream_node_id"
    t.index ["upstream_node_id"], name: "index_transfer_edges_on_upstream_node_id"
  end

  create_table "transfer_nodes", force: :cascade do |t|
    t.integer "layer", null: false
    t.bigint "bot_id"
    t.index ["bot_id"], name: "index_transfer_nodes_on_bot_id"
    t.index ["layer"], name: "index_transfer_nodes_on_layer"
  end

  add_foreign_key "transfer_edges", "transfer_nodes", column: "downstream_node_id"
  add_foreign_key "transfer_edges", "transfer_nodes", column: "upstream_node_id"
end
