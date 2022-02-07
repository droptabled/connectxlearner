# frozen_string_literal: true

class TransferNode < ApplicationRecord
  # Remember, if your ID is the downstream node, the edge points to you from above
  has_many :upstream_edges, class_name: "TransferEdge", foreign_key: "downstream_node_id"
  has_many :downstream_edges, class_name: "TransferEdge", foreign_key: "upstream_node_id"
  belongs_to :bot
end