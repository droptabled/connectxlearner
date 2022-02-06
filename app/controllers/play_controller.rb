class PlayController < ApplicationController
  before_action :get_game_and_bot

  def index
  end

  private
    def get_game_and_bot
      @bot = Bot.find(params[:bot_id])
      @game = @bot.game
    end
end
