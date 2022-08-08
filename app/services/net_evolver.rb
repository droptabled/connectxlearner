# frozen_string_literal: true

require 'benchmark'

# Evolves a bot over time by running it through game iterations
# Params:
# bot:                bot
# iterations:         int
# gamesPerIteration:  int
# NetEvolver.new(bot: Bot.last, iterations: 50, survivor_count: 5, offspring_multiplier: 5).call
class NetEvolver
  def initialize(bot:, iterations:, survivor_count:, offspring_multiplier:)
    @bot = bot
    @base_net = NeuralNet.new(parent: bot)
    @iterations = iterations
    @survivor_count = survivor_count
    @offspring_multiplier = offspring_multiplier
    @survivor_nets = [base_net] + get_mutated_nets(base_net, survivor_count - 1)
  end

  # Create survivor_count * offspring_multiplier slightly randomized versions of the original bot
  # Play games against each other (and the original) round robin
  # promote the best survivor_count amount of survivors to the next version
  def call
    iterations.times do |n|
      @survivor_nets = evolve
      printf("\rProgress: %f", n / iterations.to_f * 100)
    end

    @survivor_nets.map(&:save_evolved_net)
  end

  private

  attr_reader :iterations, :base_net, :survivor_count, :offspring_multiplier
  attr_accessor :survivor_nets

  def round_robin(nets)
    nets_and_wins = nets.map.with_index { |net, id| { id: id, wins: 0, net: net } }
    nets_and_wins.combination(2) do |faceoff_player_nets|
      game = BotGameEvaluator.new(player_nets: faceoff_player_nets.pluck(:net))
      winner_id = game.play

      # if winner_id is -1 no one won
      faceoff_player_nets[winner_id][:wins] += 1 if winner_id >= 0
    end
    nets_and_wins.sort_by { |x| x[:wins] }.reverse
  end

  def evolve
    all_nets = @survivor_nets.map { |base| [base] + get_mutated_nets(base, offspring_multiplier - 1) }.flatten

    results = round_robin(all_nets)
    results = results.sort_by { |x| x[:wins] }.reverse

    results[0..(survivor_count - 1)].map { |x| x[:net] }
  end

  def get_mutated_nets(net, num_children)
    num_children.times.map { NeuralNet.new(parent: net, mutation_weight: 1.0) }
  end
end
