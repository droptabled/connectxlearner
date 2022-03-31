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
  def initialize(bot:, iterations:, gamesPerIteration:)
    @bot = bot
  end

  # Create 4 slightly randomized versions of the original bot
  # Play N games against each other (and the original) round robin
  # promote the best performer to the next version

  private
    attr_reader :bot, :result
end