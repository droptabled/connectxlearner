class CreateActiveGames < ActiveRecord::Migration[6.1]
  def change
    create_table :active_games do |t|
      t.references :bot, null: false
      t.float :game_array, array: true, null: false
      t.integer :turn, default: 1
      t.string :url_param

      t.timestamps
    end
  end
end
