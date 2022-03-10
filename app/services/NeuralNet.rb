# frozen_string_literal: true

class NeuralNet
  def initialize(bot)
    @bot = bot.preload(transfer_nodes: :transfer_edges)
  end

  def getValue(game_array)
    input_vector = game_array.flatten
    max_layer.times do |depth|
      bot.transfer_nodes.where(layer: depth + 1)
      input_vector * transform_layer[depth]
    end
  end
end
