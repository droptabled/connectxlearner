# frozen_string_literal: true

class Bot < ApplicationRecord
  belongs_to :game
  has_many :transfer_layers

  def max_layer
    transfer_layers.maximum(:depth)
  end
end
