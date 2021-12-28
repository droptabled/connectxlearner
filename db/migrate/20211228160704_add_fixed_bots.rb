class AddFixedBots < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :static, :boolean
  end
end
