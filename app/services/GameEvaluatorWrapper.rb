# frozen_string_literal: true

require 'matrix'

# Wraps GameEvaluator to provide a consistent player1 = 1 player2 = -1 ID set for learning
class GameEvaluatorWrapper < GameEvaluator

  def initialize(player1:, player2:, height:, width:)
    @player1 = player1
    @player2 = @player2
    super(height: height, width: width)
  end
  
  def playPiece(player:, column:)
    if player == player1
      super(playerId: 1, column: column)
    elsif player == player2
      super(playerId: -1, column: column)
    else
      raise ArgumentError.new("Bot must be either #{player1.id} or #{player2.id} id")
    end
  end

  private
    attr_reader :player1, :player2
end