# frozen_string_literal: true

require 'nmatrix'

class TransferLayer < ApplicationRecord
  belongs_to :bot

  def node_array
    @node_array ||= NMatrix.new([row_count, col_count], layer_matrix)
  end
end
