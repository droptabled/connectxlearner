class PlayController < ApplicationController
  before_action :get_game_and_bot

  def index
  end

  def create
    opponent = Bot.find(params[:opponent_id])
    AdversaryEvolution.new(@bot, opponent, iterations: params[:times].to_i).call
  end

  private
    def get_game_and_bot
      @bot = Bot.find(params[:bot_id])
      @game = @bot.game
    end
end
