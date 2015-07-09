require 'rails_helper'

describe Spot do
  let(:game) { Game.create!}
  let(:user) { User.create! }
  let(:spot) { Spot.new(location: { type: 'Point', coordinates: [118.3240, 34.0937] }, game: game) }

  describe '#distance_from_last_spot' do
    subject { spot.distance_from_last_spot }

    context 'when there is no last spot' do
      it { expect(subject).to be_nil }
    end
    context 'at the same spot spot' do
      let!(:last_spot) { Spot.create!(location: { type: 'Point', coordinates: [118.3240, 34.0937] }, user: user, image: fake_file(), game: game) }
      it { expect(subject).to eq(0.0) }
    end
    context 'with a farther away last spot' do
      let!(:last_spot) { Spot.create!(location: { type: 'Point', coordinates: [118.1111, 34.1111] }, user: user, image: fake_file(),  game: game) }
      it { expect(subject).to be_within(0.00001).of(0.21361) }
    end
  end

end
