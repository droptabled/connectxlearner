# frozen_string_literal: true

class NeuralNet
  def initialize(bot1:, bot2:)
    @bot1 = bot1.preload(transfer_nodes: :transfer_edges)
    @bot2 = bot2.preload(transfer_edges: :transfer_nodes)
    @game = bot1.game
  end

  def play
    game_evaluator = GameEvaluatorWrapper.new(player1: bot1, player2: bot2, height: game.height, width: game.width)
    current_player = bot1
    current_player = bot2 if rand > 0.5 

    (game.height * game.width).times do |turn|
      net_value = 1 # TODO - call neural net and grab column selector
      game_evaluator.playPiece(player: current_player, column: net_value)
    end
  end

  def save
    bot
  end
  
  private
    attr_reader :bot1, :bot2, :game
end