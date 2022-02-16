# frozen_string_literal: true

require 'matrix'

class GameEvaluator
  def initialize(height:, width:)
    game_array = Matrix.zero(height, width)
    col_tracker = Array.new(width, 0)
  end
  
  def playPiece(playerId:, column:)
    raise StandardError.new("Column #{column} is full") if col_tracker[column] >= (g.row_count - 1)
    game_array[col_tracker[column], column] = playerId
    col_tracker[column] += 1
    checkVictory
  end

  private
    attr_accessor :game_array, :col_tracker

    def checkVictory
    end
end