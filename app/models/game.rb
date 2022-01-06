# frozen_string_literal: true

class Game < ApplicationRecord
    has_and_belongs_to_many :bots
end
