# frozen_string_literal: true

require 'nmatrix'

# Handles the game logic and victory determination
# Return value is the index of the player that won
# Human plays on 1, Bot plays on 0
# Returns -1 on tie
# Params:
# bot: Bot you want to play against
class PlayerGameEvaluator < GameEvaluator
  def initialize(bot:)
    @bot = bot
    @net = NeuralNet.new(parent: bot)
    super(
      game: bot.game,
      player_count: 2,
      first_player_index: rand(2) # Randomly select who goes first
    )
  end

  def play
    set_empty_state

    (game.height * game.width).times do
      result = nil
      if turn_index == 1
        game_values = prompt_user
        result = play_piece(id: turn_index, col: game_values)
      else
        game_values = net.get_value(get_player_game_state(turn_index))
        result = play_piece(id: turn_index, col: max_playable_column(game_values))
      end

      GameDisplayer.show(matrix: @game_array, empty_value: EMPTY_VALUE, empty_length: 3)
      return result unless result == CONTINUE

      @turn_index = (turn_index + 1) % 2
    end
  end

  private

  attr_reader :net, :bot

  def prompt_user
    puts "Play a column from 1-#{bot.game.width}"
    result = gets.chomp.to_i - 1
    result.clamp(0, bot.game.width - 1)
  end

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
