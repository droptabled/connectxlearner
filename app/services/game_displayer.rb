# frozen_string_literal: true

require 'matrix'

# Utility module to output game matrix more nicely
module GameDisplayer
  def self.show(matrix)
    puts "Game Array: #{matrix.row_count} x #{matrix.column_count}"
    puts "-------------------------------------"
    matrix.row_vectors.reverse.each do |row|
      puts row.to_a.join(" | ")
    end
    puts "-------------------------------------"
    nil # suppress vector output
  end
end
