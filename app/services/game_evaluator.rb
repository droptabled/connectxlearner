# frozen_string_literal: true

require 'matrix'

# Handles the game logic and victory determination
# Params:
# players: Iterable of bots
class GameEvaluator
  TIE = -1
  CONTINUE = 0

  def initialize(player_nets:)
    @nets = player_nets

    players = player_nets.map(&:bot)
    @game = players.first.game
    @player_ids = players.map(&:id)

    @game_array = Matrix.zero(@game.height, @game.width)
    @col_tracker = Array.new(@game.width, 0)
  end

  def play
    # Flip a coin to see who goes first
    turn_index = rand.round

    (game.height * game.width).times do
      net_value = nets[turn_index].get_value(game_array)
      result = play_piece(player_id: player_ids[turn_index], col: net_value)
      unless result == CONTINUE
        @game_array = Matrix.zero(game.height, game.width)
        @col_tracker = Array.new(@game.width, 0)
        return result
      end
      turn_index = (turn_index + 1) % 2
    end
  end

  def play_piece(player_id:, col:)
    raise StandardError.new("Column #{col} is full") if (col_tracker[col] + 1) > (game_array.row_count - 1)

    # play the piece
    game_array[col_tracker[col], col] = player_id
    result = check_victory(row: col_tracker[col], col: col)
    col_tracker[col] += 1

    # check if anyone won
    # If the gamearray is full and no one's won its a tie
    if col_tracker.uniq == [game_array.row_count - 1]
      TIE
    elsif result
      result
    else
      CONTINUE
    end
  end

  # Get the game state from the perspective of player
  # 1 = your pieces
  # -1 = enemy pieces
  def get_player_game_state(player_id)
    game_array.map do |x|
      case x
      when player_id
        1
      when 0
        0
      else
        -1
      end
    end
  end

  private

  attr_reader :player_ids, :game, :nets
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

    player_id = game_array[row, col]
    player_direction = 1
    (1..bounded_count).each do |n|
      if game_array[row + n * vertical, col + n * horizontal] == player_id
        player_direction += 1
      else
        return player_direction
      end
    end

    player_direction
  end
end
