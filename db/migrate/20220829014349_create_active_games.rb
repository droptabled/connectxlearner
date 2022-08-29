class CreateActiveGames < ActiveRecord::Migration[6.1]
  def change
    create_table :active_games do |t|
      t.references :bot, null: false
      t.references :game, null: false
      t.float :game_array, array: true, null: false
      t.integer :turn, default: 0

      t.timestamps
    end
  end
end
