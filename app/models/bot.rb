# frozen_string_literal: true

class Bot < ApplicationRecord
  belongs_to :game
  belongs_to :bot, optional: true
  has_many :transfer_layers

  def max_layer
    @max_layer ||= transfer_layers.maximum(:depth) || 0
  end

  def display_name
    if evolution_count.positive?
      "#{name}_#{evolution_count}"
    else
      name
    end
  end
end
