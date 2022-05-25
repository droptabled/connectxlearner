# frozen_string_literal: true

class CreateTransferLayer < ActiveRecord::Migration[6.1]
  def change
    create_table :transfer_layers do |t|
      t.references :bot
      t.integer :layer_matrix, array: true
      t.integer :depth
      t.timestamps
    end

    add_foreign_key "transfer_layers", "bots", on_delete: :cascade
  end
end
