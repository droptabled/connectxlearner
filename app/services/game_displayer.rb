# frozen_string_literal: true

require 'matrix'

# Utility module to output game matrix more nicely
module GameDisplayer
  def self.show(matrix)
    matrix.row_vectors.reverse.each do |row|
      puts row.to_a.join(" | ")
    end
    nil # suppress vector output
  end
end
