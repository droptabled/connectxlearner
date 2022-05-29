# frozen_string_literal: true

class CreateTransferLayer < ActiveRecord::Migration[6.1]
  def change
    create_table :transfer_layers do |t|
      t.references :bot, null: false
      t.integer :layer_matrix, array: true, null: false
      t.integer :depth, null: false
      t.integer :row_count, null: false
      t.integer :col_count, null: false
      t.timestamps
    end

    add_foreign_key "transfer_layers", "bots", on_delete: :cascade
  end
end
