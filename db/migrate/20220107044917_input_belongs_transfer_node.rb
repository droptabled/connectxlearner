class InputBelongsTransferNode < ActiveRecord::Migration[5.2]
  def change
    add_reference :input_nodes, :transfer_node
  end
end
