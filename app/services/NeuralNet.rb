# frozen_string_literal: true

class NeuralNet
  def initialize(bot)
    @bot_array = Array.new(bot.max_layer)
    bot.max_layer.each do |upstream_layer|
      # skip the first layer since its the input values
      layer = upstream_layer + 1
      bot.transfer_nodes.where(layer: layer).preload(:upstream_edges).each do |node|
        @bot_array[layer].push({ node: node, weight_vector: node.upstream_edges.pluck(:weight) })
      end
    end
  end

  def getValue(game_array)
    input_vector = game_array.flatten
    max_layer.times do |depth|
      input_vector = bot_array[layer].map do |node|
        input_vector * node[:weight_vector]
      end
    end

    # return the index of the max value
    input_vector.each_with_index.max[1]
  end

  private
    attr_reader :bot_array
end
