class CreateTransferNode < ActiveRecord::Migration[5.2]
  def change
    create_table :transfer_nodes do |t|
      t.integer :layer, null: false, index: true
      t.references :bot
    end
  end
end
