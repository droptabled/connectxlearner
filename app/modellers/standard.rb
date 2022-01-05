# frozen_string_literal: true

class StandardModeller
  def generateInputNodes(game)
    game.width.times do |x|
      game.height.times do |y|
        InputNode.create(game: game, x: x, y: y, owner: 0)
      end
    end
  end
end