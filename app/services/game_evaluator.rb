# frozen_string_literal: true

require 'nmatrix'

# Handles the game logic and victory determination
# Return value is the index of the player_net that won
# Returns -1 on tie
# Players are internally assigned ids by order of player_nets starting from 1
# Params:
# players: Iterable of bots
class GameEvaluator
  TIE = -1
  CONTINUE = 0

  def initialize(player_nets:)
    @nets = player_nets
    @game = player_nets.first.bot.game
    # the play piece ids need to be incremented by 1 to not conflict with the empty state
    @piece_ids = (1..player_nets.count).to_a
    @player_count = player_nets.count
  end

  def play
    # Randomly select who goes first
    turn_index = rand(player_count)
    set_empty_state

    (game.height * game.width).times do
      game_values = nets[turn_index].get_value(get_player_game_state(piece_ids[turn_index]))
      result = play_piece(id: piece_ids[turn_index], col: max_playable_column(game_values))
      unless result == CONTINUE
        # GameDisplayer.show(@game_array)
        return result
      end

      turn_index = (turn_index + 1) % player_count
    end
  end

  private

  attr_reader :game, :nets, :piece_ids, :player_count
  attr_accessor :col_tracker, :game_array

  def check_victory(row:, col:)
    raise StandardError.new("No player token") if game_array[row, col].zero?

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
      row_index = row_index.positive? ? [row_index, game_array.row_count - 1].min : 0
      bounded_count = (row_index - row).abs
    end
    unless horizontal.zero?
      col_index = col + count * horizontal
      col_index = col_index.positive? ? [col_index, game_array.column_count - 1].min : 0
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

  # Get the game state from the perspective of player
  # 1 = your pieces
  # -1 = enemy pieces
  def get_player_game_state(id)
    game_array.map do |x|
      case x
      when id
        1.0
      when 0
        -0.0001 # give a small negative value to allow for some strategy in the empty initial state
      else
        -1.0
      end
    end
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
    # If the gamearray is full and no one's won its a tie
    if col_tracker.uniq == [game_array.row_count - 1]
      TIE
    elsif result
      id - 1 # Subtract 1 to get back to the regular index instead of game index
    else
      CONTINUE
    end
  end

  def set_empty_state
    @game_array = NMatrix.new([@game.height, @game.width], 0.0)
    @col_tracker = NMatrix.new([1, @game.width], 0)
  end
end
