# frozen_string_literal: true

class Bot < ApplicationRecord
  belongs_to :game
  has_many :transfer_nodes

  def max_layer
    @max_layer ||= transfer_nodes.maximum(:layer)
  end
end
