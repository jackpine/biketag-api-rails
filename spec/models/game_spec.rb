require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "#name" do
    it 'has a name' do
      game = Game.new
      game.id = 3
      expect(game.name).to eq("Game 3")
    end
  end
end
