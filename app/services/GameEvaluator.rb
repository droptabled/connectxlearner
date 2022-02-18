# frozen_string_literal: true

require 'matrix'

class GameEvaluator
  def initialize(height:, width:)
    game_array = Matrix.zero(height, width)
    col_tracker = Array.new(width, 0)
  end
  
  def playPiece(playerId:, column:)
    raise StandardError.new("Column #{column} is full") if col_tracker[column] >= (game_array.row_count - 1)

    game_array[col_tracker[column], column] = playerId
    col_tracker[column] += 1
    checkVictory(row: col_tracker[column], column: column)
  end

  private
    attr_accessor :game_array, :col_tracker

    def checkVictory(row:, column:)
      raise StandardError.new("No player token") if game_array[height, width] == 0

      # Vertical

      # Horizontal

      # Diagonal NE - SW

      # Diagonal SE - NW
    end

    # Horizontal -1 (West), 1 (East)
    # Vertical -1 (South), 1 (North)
    def checkDirection(horizontal:, vertical:)
end