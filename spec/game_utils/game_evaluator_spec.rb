# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEvaluator do
  let(:game) { Game.create(width: 10, height: 5) }
  let(:game_evaluator) { GameEvaluator.new(game: game, player_count: 2, first_player_index: 1) }

  describe "#play_turn" do
    it "plays the piece in the column you expect" do
      game_evaluator.play_turn(5)

      expect(game_evaluator.game_array[0, 5]).to eq(1)
    end

    it "plays pieces by alternating ids" do
      game_evaluator.play_turn(5)
      game_evaluator.play_turn(4)

      expect(game_evaluator.game_array[0, 5]).to eq(1)
      expect(game_evaluator.game_array[0, 4]).to eq(0)
    end
  end

  describe "#check_victory" do
    it "detects victory in a row" do
      game_evaluator.play_turn(8)
      game_evaluator.play_turn(1)
      game_evaluator.play_turn(6)
      game_evaluator.play_turn(1)
      game_evaluator.play_turn(7)
      game_evaluator.play_turn(1)
      result = game_evaluator.play_turn(5)

      expect(result).to eq(1)
    end

    it "detects victory in a column" do
      game_evaluator.play_turn(5)
      game_evaluator.play_turn(1)
      game_evaluator.play_turn(5)
      game_evaluator.play_turn(1)
      game_evaluator.play_turn(5)
      game_evaluator.play_turn(1)
      result = game_evaluator.play_turn(5)

      expect(result).to eq(1)
    end

    it "detects voctpry in a diagonal" do
      game_evaluator.play_turn(5) # 1
      game_evaluator.play_turn(6) # 0
      game_evaluator.play_turn(6) # 1
      game_evaluator.play_turn(8) # 0
      game_evaluator.play_turn(8) # 1
      game_evaluator.play_turn(8) # 0
      game_evaluator.play_turn(8) # 1
      game_evaluator.play_turn(8) # 0
      game_evaluator.play_turn(7) # 1
      game_evaluator.play_turn(7) # 0
      result = game_evaluator.play_turn(7) # 1

      # End state
      # x x x 1
      # x x 1 0
      # x 1 0 1
      # 1 0 1 0

      expect(result).to eq(1)
    end
  end
end
