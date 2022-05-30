# frozen_string_literal: true

# Class to generate a neural net to the database
class StandardBuilder
  def initialize(bot)
    @bot = bot
  end

  def call
    ActiveRecord::Base.transaction do
      generate_input_layer
      5.times do
        generate_layer(50)
      end
      generate_output_layer

      # First we generate the layers with their desired output length (cols)
      # Then iterate and tie them with the required input length (rows)
      generate_mappings
    end
  end

  private

  attr_reader :bot

  def generate_layer(count)
    last_layer = bot.transfer_layers.order(depth: :DESC).first
    raise 'Cannot generate a layer for a bot that has no existing layers' unless last_layer

    TransferLayer.create!(
      bot: bot,
      layer_matrix: [],
      depth: last_layer.depth + 1,
      row_count: 0,
      col_count: count
    )
  end

  def generate_input_layer
    raise 'Cannot generate input layer for a bot that already has layers' unless bot.max_layer.zero?

    TransferLayer.create!(
      bot: bot,
      layer_matrix: [],
      depth: 0,
      row_count: bot.game.height * bot.game.width,
      col_count: 0
    )
  end

  def generate_output_layer
    generate_layer(bot.game.width)
  end

  def generate_mappings
    layers = bot.transfer_layers.to_a

    # Update the input node with the required output length for layer 1
    layers[0].update!(
      col_count: layers[1].row_count,
      layer_matrix: Array.new(layers[0].row_count * layers[1].row_count, 0)
    )

    # Iterate on, using the output length from the layer above as input length
    layers[1..].each do |layer|
      row_count = layers[layer[:depth] - 1].col_count
      layer.update!(
        row_count: row_count,
        layer_matrix: Array.new(row_count * layer.col_count, 0)
      )
    end
  end
end
