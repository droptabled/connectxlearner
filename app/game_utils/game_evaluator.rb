# frozen_string_literal: true

require 'nmatrix'

# Handles the game logic and victory determination
# Returns -1 on tie
# Players are internally assigned ids starting from 0
# Params:
# game:                   Game model        The game model the evaluator is played on
# player_count:           integer           The number of players playing
# first_player_index:     integer           Index of the player who plays first (from 0 to player_count - 1)
class GameEvaluator
  TIE = -2
  CONTINUE = -1

  # Value of an empty array elem
  # give a small positive value to allow for some strategy in the empty initial state
  EMPTY_VALUE = 0.0001

  def initialize(game:, player_count:, first_player_index:)
    @game = game
    @player_count = player_count
    @turn_index = first_player_index
    set_empty_state
  end

  def play_turn(column)
    val = play_piece(id: turn_index, col: column)
    @turn_index = (turn_index + 1) % player_count
    val
  end

  # def player_play_piece(piece_index, column)
  #   play_piece(id: piece_ids[piece_index], col: column)
  # end

  private

  attr_reader :game, :player_count, :turn_index
  attr_accessor :col_tracker, :game_array

  def check_victory(row:, col:)
    raise StandardError.new("No player token") if game_array[row, col] == EMPTY_VALUE

    check_directions(row: row, col: col, vertical: 1) ||                  # Vertical N - S
      check_directions(row: row, col: col, horizontal: 1) ||              # Horizontal E - W
      check_directions(row: row, col: col, horizontal: 1, vertical: 1) || # Diagonal NE - SW
      check_directions(row: row, col: col, horizontal: 1, vertical: -1)   # Diagonal SE - NW
  end

  def check_directions(row:, col:, horizontal: 0, vertical: 0, target_length: 4)
    neg_length = get_length(
      row: row,
      col: col,
      horizontal: horizontal * -1,
      vertical: vertical * -1,
      count: target_length
    )

    return true if neg_length == target_length

    pos_length = get_length(
      row: row,
      col: col,
      horizontal: horizontal,
      vertical: vertical,
      count: target_length - neg_length + 1
    )
    # subtract 1 since the center node is counted twice
    neg_length + pos_length - 1 >= target_length
  end

  # Horizontal -1 (West), 1 (East)
  # Vertical -1 (South), 1 (North)
  def get_length(row:, col:, horizontal: 0, vertical: 0, count: 4)
    bounded_count = nil
    unless vertical.zero?
      row_index = row + count * vertical
      row_index = row_index.positive? ? [row_index, game_array.rows - 1].min : 0
      bounded_count = (row_index - row).abs
    end
    unless horizontal.zero?
      col_index = col + count * horizontal
      col_index = col_index.positive? ? [col_index, game_array.cols - 1].min : 0
      diff = (col_index - col).abs
      bounded_count = bounded_count ? [diff, bounded_count].min : diff
    end

    id = game_array[row, col]
    player_direction = 1
    (1..bounded_count).each do |n|
      if game_array[row + n * vertical, col + n * horizontal] == id
        player_direction += 1
      else
        return player_direction
      end
    end

    player_direction
  end

  def max_playable_column(output_array)
    output_array.find { |hash| col_tracker[hash[:index]] < @game.height - 1 }[:index]
  end

  def play_piece(id:, col:)
    # play the piece
    game_array[col_tracker[col], col] = id
    result = check_victory(row: col_tracker[col], col: col)
    col_tracker[col] += 1

    # check if anyone won
    if result
      id
    elsif col_tracker.uniq == [game_array.rows - 1]
      # If the gamearray is full and no one's won its a tie
      TIE
    else
      CONTINUE
    end
  end

  def set_empty_state
    @game_array = NMatrix.new([@game.height, @game.width], EMPTY_VALUE)
    @col_tracker = NMatrix.new([1, @game.width], 0)
  end
end
