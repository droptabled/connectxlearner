# frozen_string_literal: true

class Bot < ApplicationRecord
  belongs_to :game
  has_many :transfer_nodes
end
