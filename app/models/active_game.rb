# frozen_string_literal: true

class ActiveGame < ApplicationRecord
  belongs_to :game
  belongs_to :bot
end
