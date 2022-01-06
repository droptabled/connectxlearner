class CreateInputNode < ActiveRecord::Migration[5.2]
  def change
    create_table :input_nodes do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.boolean :owner, null: true
      t.references :game, null: false, index: true

      t.timestamps
    end
  end
end
