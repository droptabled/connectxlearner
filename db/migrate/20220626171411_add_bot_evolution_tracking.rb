class AddBotEvolutionTracking < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :evolution_count, :integer, default: 0, null: false
    add_column :bots, :parent_bot, :bigint
  end
end
