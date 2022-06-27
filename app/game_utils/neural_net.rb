# frozen_string_literal: true

require 'nmatrix'

# Loads a bot neural net from database into memory
class NeuralNet
  def initialize(bot:, mutation_weight: nil)
    case bot
    when NeuralNet
      @mutation_count = bot.instance_variable_get(:@mutation_count)
      @bot = bot.bot
      @matrix_transfer_layers = bot.matrix_transfer_layers
    when Bot
      @mutation_count = 0
      @bot = bot
      @matrix_transfer_layers = bot.transfer_layers.order(:depth).to_a.map! do |layer|
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
    @mutation_count += 1
    matrix_transfer_layers.each do |transfer_layer|
      transfer_layer[:weight_array].map! { |x| x + rand(-max_weight..max_weight) }
    end
  end

  def save_evolved_net
    evolved_bot = bot.dup
    evolved_bot.parent_bot = bot
    evolved_bot.evolution_count = bot.evolution_count + @mutation_count
    evolved_bot.save!

    matrix_transfer_layers.each do |layer|
      new_layer = layer[:layer].dup
      new_layer.bot = evolved_bot
      new_layer.layer_matrix = layer[:weight_array].to_a
      new_layer.save!
    end
  end

  attr_reader :matrix_transfer_layers, :bot
end
