require 'rails_helper'

describe Guess do
  let(:spot) { Spot.new(location: { type: 'Point', coordinates: [-118.3240, 34.0937] }) }
  let(:guess) { Guess.new(image: fake_file, user: FactoryGirl.build(:user), spot: spot, location: location) }
  let(:location) { spot.location }

  describe '#close_enough?' do
    subject { guess.close_enough? }

    context 'right on the spot' do
      let(:location) { spot.location }
      it { is_expected.to eq(true) }
    end
    context 'near the spot' do
      let(:location) { { type: 'Point', coordinates: [-118.323957, 34.093207] } }
      it { is_expected.to eq(true) }
    end
    context 'a little too far from the spot' do
      let(:location) { { type: 'Point', coordinates: [-118.324000, 34.092692] } }
      it { is_expected.to eq(false) }
    end
    context 'far from the spot' do
      let(:location) { { type: 'Point', coordinates: [-118.314891, 34.092914] } }
      it { is_expected.to eq(false) }
    end
  end

  describe '#promote_to_spot!' do
    it 'creates a new game with this guess as the current spot' do
      spot = guess.promote_to_spot!
      expect(spot.game.current_spot.location).to eq(guess.location)
    end

    it 'should not create a new game if creating the guess fails' do
      expect(Spot).to receive(:create!).and_raise(RuntimeError.new("fake error"))

      expect {
        expect {
          guess.promote_to_spot!
        }.to raise_error(RuntimeError)
      }.not_to change { Game.count }
    end
  end
end
