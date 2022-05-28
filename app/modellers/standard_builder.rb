# frozen_string_literal: true

# Class to generate a neural net to the database
class StandardBuilder
  def initialize(bot)
    @bot = bot
  end

  def generate_layer(count)
    last_layer = bot.max_layer
    generate_nodes(layer: last_layer + 1, count: count)
  end

  # Generate output nodes, which is one of the columns
  def generate_output_layer
    generate_layer(bot.game.width)
  end

  private

  attr_reader :bot

  def generate_nodes(layer:, count:)
    new_nodes = Array.new(count, 0)
    TransferLayer.create(bot: bot, depth: layer, layer_matrix: new_nodes)
  end
end
