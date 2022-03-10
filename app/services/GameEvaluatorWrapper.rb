# frozen_string_literal: true

require 'matrix'

# Wraps GameEvaluator to provide a consistent player1 = 1 player2 = -1 ID set for learning
class GameEvaluatorWrapper < GameEvaluator
  def initialize(players:, height:, width:)
    @players = players
    super(height: height, width: width)
  end

  def playPiece(player:, column:)
    if player == players[0]
      super(playerId: 1, column: column)
    elsif player == players[1]
      super(playerId: -1, column: column)
    else
      raise ArgumentError.new("Bot must be either #{players[0].id} or #{players[1].id} id")
    end
  end

  private
    attr_reader :players
end
