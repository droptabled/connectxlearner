# frozen_string_literal: true

class PlayController < ApplicationController
  before_action :set_game_and_bot

  def index
  end

  def create
    NetEvolver.new(@bot, iterations: params[:times].to_i).call
  end

  private

  def set_game_and_bot
    @bot = Bot.find(params[:bot_id])
    @game = @bot.game
  end
end
