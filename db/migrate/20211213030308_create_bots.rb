class CreateBots < ActiveRecord::Migration[5.2]
  def change
    create_table :bots do |t|
      t.string :name
      t.boolean :static
      t.references :game

      t.timestamps
    end
  end
end
