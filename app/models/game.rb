# frozen_string_literal: true

class Game < ApplicationRecord
    has_many :bots

    validates :width, presence: true
    validates :height, presence: true
end
