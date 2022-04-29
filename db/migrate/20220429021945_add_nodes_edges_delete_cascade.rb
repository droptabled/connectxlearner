# frozen_string_literal: true

class AddNodesEdgesDeleteCascade < ActiveRecord::Migration[6.1]
  def change
    # remove existing keys
    remove_foreign_key "transfer_edges", "transfer_nodes", column: "downstream_node_id"
    remove_foreign_key "transfer_edges", "transfer_nodes", column: "upstream_node_id"

    # recreate them with constraints
    add_foreign_key "transfer_edges", "transfer_nodes", column: "downstream_node_id", on_delete: :cascade
    add_foreign_key "transfer_edges", "transfer_nodes", column: "upstream_node_id", on_delete: :cascade

    # add transfer node to bot fks which were missed the first time
    add_foreign_key "transfer_nodes", "bots", on_delete: :cascade
  end
end
