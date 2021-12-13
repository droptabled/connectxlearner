class CreateJoinTableGameBot < ActiveRecord::Migration[5.2]
  def change
    create_join_table :games, :bots do |t|
      t.index [:game_id, :bot_id]
      # t.index [:bot_id, :game_id]
    end
  end
end
