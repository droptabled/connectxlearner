# frozen_string_literal: true

class TransferEdge < ApplicationRecord
  belongs_to :upstream_node, class_name: "TransferNode", foreign_key: "upstream_node_id"
  belongs_to :downstream_node, class_name: "TransferNode", foreign_key: "downstream_node_id"
end