# frozen_string_literal: true

class Bot < ApplicationRecord
  belongs_to :game
  has_many :transfer_layers

  def max_layer
    @max_layer ||= transfer_layers.maximum(:depth) || 0
  end
end
