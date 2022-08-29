# frozen_string_literal: true

class BotPlayChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bot_game:#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
