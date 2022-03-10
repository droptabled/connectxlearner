# frozen_string_literal: true

class AdversaryGameEvolution
  def initialize(bot1:, bot2:)
    @players = [
      bot1,
      bot2
    ]
    @nets = [
      NeuralNet.new(bot1),
      NeuralNet.new(bot2)
    ]
    @game = bot1.game
  end

  def play
    game_evaluator = GameEvaluatorWrapper.new(players: players, height: game.height, width: game.width)
    
    # Flip a coin to see who goes first
    turn_index = rand.round

    (game.height * game.width).times do |turn|
      net_value = 1 # TODO - call neural net and grab column selector
      net_value = nets[turn_index].getValue(game_evaluator.game_array)
      game_evaluator.playPiece(player: players[turn_index], column: net_value)
      turn_index = (turn_index + 1) % 2
    end
  end

  def save
    bot
  end

  private
    attr_reader :players, :game
end
