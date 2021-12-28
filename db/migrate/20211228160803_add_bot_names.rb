class AddBotNames < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :name, :string
  end
end
