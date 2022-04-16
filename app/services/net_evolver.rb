# frozen_string_literal: true

# Evolves a bot over time by running it through game iterations
# Params:
# bot:                bot
# iterations:         int
# gamesPerIteration:  int
class NetEvolver
  # result based on constant in GameEvalulator
  # TODO: Extract constants to separate include
  # TIE = -1
  # CONTINUE = 0
  # WON = 1
  def initialize(bot:, iterations:, games_per_iteration:)
    @bot = bot
    @base_net = NeuralNet.new(bot: bot)
    @iterations = iterations
    @games_per_iteration = games_per_iteration
  end

  # Create N slightly randomized versions of the original bot
  # Play M games against each other (and the original) round robin
  # promote the best performer to the next version

  def call
    @iterations.times do
      @base_net = evolve
    end

    update_net
  end

  def evolve
    all_nets = [base_net] + get_mutated_nets(4)
    all_nets.map! { |net| { wins: 0, net: net } }

    # Round robin, playing @games_per_iteration games each time
    all_nets.combination(2).each do |player_nets|
      game = GameEvaluator.new(player_nets: player_nets.pluck(:net))
      @games_per_iteration.times do
        result = game.play
        binding.pry
        # TODO: update all_nets with result of game
      end
    end

  end

  def get_mutated_nets(num_children)
    num_children.times.map { NeuralNet.new(bot: base_net, mutation_weight: 10) }
  end

  def update_net
    binding.pry
    # TODO: update the weights in the database with hte values in base_net
  end

  private

  attr_reader :base_net, :result
end
