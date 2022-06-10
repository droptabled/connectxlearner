# frozen_string_literal: true

require 'nmatrix'

# Loads a bot neural net from database into memory
class NeuralNet
  def initialize(bot:, mutation_weight: nil)
    case bot
    when NeuralNet
      @bot = bot.bot
      @matrix_transfer_layers = bot.matrix_transfer_layers
    when Bot
      @bot = bot
      @matrix_transfer_layers = bot.transfer_layers.to_a.map! do |layer|
        {
          weight_array: NMatrix.new([layer.row_count, layer.col_count], layer.layer_matrix),
          layer: layer
        }
      end
    else
      raise "Bot initializer class must be NeuralNet or Bot, not #{bot.class}"
    end

    mutate(mutation_weight) if mutation_weight
  end

  def get_value(game_array)
    input_vector = N[game_array.flat_map.to_a]
    (bot.max_layer + 1).times do |depth|
      input_vector = input_vector.dot(matrix_transfer_layers[depth][:weight_array])
    end

    # return the selection vector sorted by max weight, descending order
    input_vector.to_a.each_with_index.map { |val, index| { value: val, index: index } }.sort { |h| h[:value] }.reverse
  end

  def mutate(max_weight)
    matrix_transfer_layers.each do |transfer_layer|
      transfer_layer[:weight_array].map! { |x| x + rand(-max_weight..max_weight) }
    end
  end

  def save_net
    puts "Implement the net saver dammit"
  end

  attr_reader :matrix_transfer_layers, :bot
end
