# frozen_string_literal: true

class NeuralNet
  def initialize(bot:)
    @bot = bot.preload(transfer_nodes: :transfer_edges)
  end
end