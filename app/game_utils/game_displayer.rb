# frozen_string_literal: true

# Utility module to output game matrix more nicely
module GameDisplayer
  def self.show(matrix:, empty_value:, empty_length:)
    str = "X" * empty_length
    puts "Game Array: #{matrix.rows} x #{matrix.cols}"
    puts "-------------------------------------"
    matrix.each_row.reverse_each do |row|
      puts row.to_a.map { |v| v == empty_value ? str : v }.join(" | ")
    end
    puts "-------------------------------------"
    nil # suppress vector output
  end
end
