# frozen_string_literal: true

# Class to generate a neural net to the database
class StandardBuilder
  def initialize(bot)
    @bot = bot
  end

  def call
    ActiveRecord::Base.transaction do
      generate_input_layer(50)
      5.times do
        generate_layer(50)
      end
      generate_output_layer
    end
  end

  private

  attr_reader :bot

  def generate_layer(count)
    last_layer = bot.transfer_layers.order(depth: :DESC).first
    raise 'Cannot generate a layer for a bot that has no existing layers' unless last_layer

    TransferLayer.create!(
      bot: bot,
      layer_matrix: Array.new(last_layer.col_count * count, 0.0),
      depth: last_layer.depth + 1,
      row_count: last_layer.col_count,
      col_count: count
    )
  end

  def generate_input_layer(count)
    TransferLayer.create!(
      bot: bot,
      layer_matrix: Array.new(bot.game.height * bot.game.width * count, 0.0),
      depth: 0,
      row_count: bot.game.height * bot.game.width,
      col_count: count
    )
  end

  def generate_output_layer
    generate_layer(bot.game.width)
  end
end
