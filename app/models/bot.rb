# frozen_string_literal: true

class Bot < ApplicationRecord
  has_and_belongs_to_many :games
end
