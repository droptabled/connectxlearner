# frozen_string_literal: true

# Loads a bot neural net from database into memory
class NeuralNet
  def initialize(bot:, mutation_weight: nil)
    case bot
    when NeuralNet
      @transform_vectors = bot.transform_vectors
    when Bot
      @transform_vectors = Array.new(bot.max_layer) { [] }
      bot.max_layer.times.each do |upstream_layer|
        # skip the first layer since its the input values
        next if upstream_layer.zero?

        bot.transfer_nodes.where(layer: upstream_layer).preload(:upstream_edges).each do |node|
          @transform_vectors[upstream_layer].push({ node: node, weight_vector: node.upstream_edges.pluck(:weight) })
        end
      end
    else
      raise "Bot initializer class must be NeuralNet or Bot, not #{bot.class}"
    end

    mutate(mutation_weight) if mutation_weight
  end

  def get_value(game_array)
    input_vector = game_array.flatten
    max_layer.times do
      input_vector = bot_array[layer].map do |node|
        input_vector * node[:weight_vector]
      end
    end

    # return the index of the max value
    input_vector.each_with_index.max[1]
  end

  def mutate(max_weight)
    max_weight = max_weight.to_f

    @transform_vectors.each do |layer|
      layer.each do |hash|
        hash[:weight_vector] = hash[:weight_vector].map { |x| x + rand(-max_weight..max_weight) }
      end
    end
  end

  attr_reader :transform_vectors
end
