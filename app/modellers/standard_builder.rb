# frozen_string_literal: true

class StandardBuilder
  def generateInputNodes(game:, bot:)
    game.width.times do |x|
      game.height.times do |y|
        TransferNode.create(layer: 0, bot: bot)
      end
    end
  end

  def generateAndMapLayerNodes(bot:, parent_layer:, count:)
    parent_nodes = TransferNode.where(bot: bot, layer: parent_layer)
    #new_nodes = TransferNode.
  end
end