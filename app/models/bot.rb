# frozen_string_literal: true

class Bot < ApplicationRecord
  belongs_to :game
  has_many :transfer_nodes

  before_destroy :remove_nodes_edges

  def max_layer
    @max_layer ||= transfer_nodes.maximum(:layer)
  end

  # Custom deletion logic for transfer nodes and edges
  # If we did this through rails there would be on destroy run on each node - expensive!
  def remove_nodes_edges
    node_ids = Bot.transfer_nodes.pluck(:id)
    TransferEdge.where(upstream_node: node_ids).or(TransferEdge.where(downstream_node: node_ids)).delete_all
    Bot.transfer_nodes.delete_all
  end
end
