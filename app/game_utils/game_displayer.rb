# frozen_string_literal: true

# Utility module to output game matrix more nicely
module GameDisplayer
  def self.show(matrix)
    puts "Game Array: #{matrix.rows} x #{matrix.cols}"
    puts "-------------------------------------"
    matrix.each_row.reverse_each do |row|
      puts row.to_a.join(" | ")
    end
    puts "-------------------------------------"
    nil # suppress vector output
  end
end
