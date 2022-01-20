# frozen_string_literal: true

class StandardBuilder
  def generateInputNodes(game:, bot:)
    new_nodes = []
    game.width.times do |x|
      game.height.times do |y|
        new_nodes << { layer: 0, bot: bot }
      end
    end
    
    TransferNode.insert_all(new_nodes)
  end

  def generateAndMapLayerNodes(bot:, parent_layer:, count:)
    parent_nodes = TransferNode.where(bot: bot, layer: parent_layer)
    new_layer = parent_layer + 1
    new_nodes = []
    parent_nodes.map do |node|
      count.times do |count|
        new_nodes << { bot: bot, layer: new_layer }
      end
    end
    TransferNode.insert_all(new_nodes)

    new_edges = []
    parent_nodes.map do |node|
      new_nodes.map do |new_node|
        new_edges << { weight: 0, upstream_node: node, downstream_node: new_node}
      end
    end
    TransferEdge.insert_all(new_edges)
  end
end