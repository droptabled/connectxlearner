# frozen_string_literal: true

class StandardBuilder
  def initialize(bot)
    @bot = bot
  end

  def generate_input_nodes
    generate_nodes(layer: 0, count: bot.game.width * bot.game.height)
  end

  def generate_layer_nodes(count)
    last_layer = bot.transfer_nodes.maximum("layer")
    generate_nodes(layer: last_layer + 1, count: count)
    generate_connections(source_layer: last_layer, target_layer: last_layer + 1)
  end

  def generate_output_nodes
    generate_layer_nodes(bot.game.width * bot.game.height)
  end

  private

  attr_reader :bot

  def generate_nodes(layer:, count:)
    new_nodes = Array.new(count) { { layer: layer, bot_id: bot.id } }
    TransferNode.insert_all(new_nodes)
  end

  def generate_connections(source_layer:, target_layer:)
    new_edges = []
    source_node_ids = TransferNode.where(bot: bot, layer: source_layer).pluck(:id)
    target_node_ids = TransferNode.where(bot: bot, layer: target_layer).pluck(:id)

    source_node_ids.each do |source_id|
      new_edges << target_node_ids.map { |target_id| { upstream_node_id: source_id, downstream_node_id: target_id } }
    end

    TransferEdge.insert_all(new_edges.flatten)
  end
end
