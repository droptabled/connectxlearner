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

ActiveRecord::Schema.define(version: 2022_01_07_052204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "static"
    t.string "name"
  end

  create_table "bots_games", id: false, force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "bot_id", null: false
    t.index ["game_id", "bot_id"], name: "index_bots_games_on_game_id_and_bot_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "input_nodes", force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.boolean "owner"
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transfer_node_id"
    t.index ["game_id"], name: "index_input_nodes_on_game_id"
    t.index ["transfer_node_id"], name: "index_input_nodes_on_transfer_node_id"
  end

  create_table "transfer_edges", force: :cascade do |t|
    t.bigint "upstream_node_id"
    t.bigint "downstream_node_id"
    t.float "weight"
    t.index ["downstream_node_id"], name: "index_transfer_edges_on_downstream_node_id"
    t.index ["upstream_node_id"], name: "index_transfer_edges_on_upstream_node_id"
  end

  create_table "transfer_nodes", force: :cascade do |t|
    t.integer "layer", null: false
    t.index ["layer"], name: "index_transfer_nodes_on_layer"
  end

  add_foreign_key "transfer_edges", "transfer_nodes", column: "downstream_node_id"
  add_foreign_key "transfer_edges", "transfer_nodes", column: "upstream_node_id"
end
