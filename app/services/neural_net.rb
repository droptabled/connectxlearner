# frozen_string_literal: true

require 'matrix'

# Loads a bot neural net from database into memory
class NeuralNet
  def initialize(bot:, mutation_weight: nil)
    case bot
    when NeuralNet
      @transform_vectors = bot.transform_vectors
      @bot = bot.bot
    when Bot
      @bot = bot
      @transform_vectors = Array.new(bot.max_layer) { [] }

      bot.max_layer.times do |layer|
        # skip layer 0 since its the input values
        bot.transfer_nodes.where(layer: layer + 1).preload(:upstream_edges).each do |node|
          @transform_vectors[layer].push(
            {
              node: node,
              weight_vector: Vector.elements(node.upstream_edges.pluck(:weight))
            }
          )
        end
      end
    else
      raise "Bot initializer class must be NeuralNet or Bot, not #{bot.class}"
    end

    mutate(mutation_weight) if mutation_weight
  end

  def get_value(game_array)
    input_vector = Vector.elements(game_array.flat_map.to_a)
    bot.max_layer.times do |layer|
      input_vector = Vector.elements(
        transform_vectors[layer].map do |node|
          input_vector.dot(node[:weight_vector])
        end
      )
    end

    # return the selection vector sorted by max weight, descending order
    input_vector.to_a.each_with_index.map { |val, index| { value: val, index: index } }.sort { |h| h[:value] }.reverse
  end

  def mutate(max_weight)
    max_weight = max_weight.to_f

    transform_vectors.each do |layer|
      layer.each do |hash|
        hash[:weight_vector] = hash[:weight_vector].map { |x| x + rand(-max_weight..max_weight) }
      end
    end
  end

  def save_net
    puts "Implement the net saver dammit"
  end

  attr_reader :transform_vectors, :bot
end
