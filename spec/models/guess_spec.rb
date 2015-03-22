require 'rails_helper'

describe Guess do
  let(:spot) { Spot.new(location: { type: 'Point', coordinates: [-118.3240, 34.0937] }) }
  let(:guess) { Guess.new(spot: spot, location: location) }
  describe '#close_enough?' do
    subject { guess.close_enough? }
    context 'right on the spot' do
      let(:location) { spot.location }
      it { is_expected.to be_true }
    end
    context 'near the spot' do
      let(:location) { { type: 'Point', coordinates: [-118.323957, 34.093207] } }
      it { is_expected.to be_true }
    end
    context 'a little too far from the spot' do
      let(:location) { { type: 'Point', coordinates: [-118.324000, 34.092692] } }
      it { is_expected.to be_false }
    end
    context 'far from the spot' do
      let(:location) { { type: 'Point', coordinates: [-118.314891, 34.092914] } }
      it { is_expected.to be_false }
    end
  end
end
