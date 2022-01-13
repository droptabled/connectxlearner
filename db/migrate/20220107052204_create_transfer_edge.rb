class CreateTransferEdge < ActiveRecord::Migration[5.2]
  def change
    create_table :transfer_edges do |t|
      t.references :upstream_node, foreign_key: { to_table: 'transfer_nodes' }
      t.references :downstream_node, foreign_key: { to_table: 'transfer_nodes' }
      t.float :weight
    end
  end
end
