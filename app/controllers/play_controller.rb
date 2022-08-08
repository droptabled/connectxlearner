# frozen_string_literal: true

class PlayController < ApplicationController
  before_action :set_game_and_bot

  def show
  end

  private

  def set_game_and_bot
    @bot = Bot.find(params[:id])
    @game = @bot.game
  end
end
