# frozen_string_literal: true

require 'nmatrix'

# Handles the game logic and victory determination
# Return value is the index of the player_net that won
# Returns -1 on tie
# Players are internally assigned ids by order of player_nets starting from 1
# Params:
# players: Iterable of neural nets
class BotGameEvaluator < GameEvaluator
  def initialize(player_nets:)
    super(
      game: player_nets.first.bot.game,
      player_count: player_nets.count,
      first_player_index: rand(player_nets.count) # Randomly select who goes first
    )
    @nets = player_nets
  end

  def play
    set_empty_state

    (game.height * game.width).times do
      game_values = nets[turn_index].get_value(get_player_game_state(turn_index))
      result = play_piece(id: turn_index, col: max_playable_column(game_values))
      # GameDisplayer.show(matrix: @game_array, empty_value: EMPTY_VALUE, empty_length: 3)
      return result unless result == CONTINUE

      @turn_index = (turn_index + 1) % player_count
    end
  end

  private

  attr_reader :nets

  # Get the game state from the perspective of player
  # 1 = your pieces
  # -1 = enemy pieces
  def get_player_game_state(id)
    game_array.map do |x|
      case x
      when id
        1.0
      when EMPTY_VALUE
        EMPTY_VALUE
      else
        -1.0
      end
    end
  end
end
