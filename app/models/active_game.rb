# frozen_string_literal: true

# Model for recording and saving active bot games with human players
# Humans play as 1, bot as 2
class ActiveGame < ApplicationRecord
  belongs_to :bot

  def initialize(params)
    super(params)

    if bot && game_array.nil?
      self.game_array = Array.new(bot.game.height) { Array.new(bot.game.width, 0) }
    end
  end
end
