require 'rails_helper'

describe Spot do
  let(:game) { Game.create! }
  let(:user) { User.create_for_game! }
  let(:spot) { Spot.new(location: { type: 'Point', coordinates: [-118.3240, 34.0937] }, user: user, image: image,  game: game) }
  let(:image) { fake_file }

  describe 'validations' do
    describe '#distance_from_last_spot' do
      context 'when there is no last spot' do
        it 'should be valid' do
          expect(spot).to be_valid
        end
      end
      context 'at a nearby spot' do
        let!(:last_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.3241, 34.0936] }, user: user, image: image, game: game) }
        it 'should be invalid' do
          expect(spot).not_to be_valid
        end
      end
      context 'farther away from the last spot' do
        let!(:last_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.1111, 34.1111] }, user: user, image: image,  game: game) }
        it 'should be valid' do
          expect(spot).to be_valid
        end
      end
    end
  end

  describe '#distance_from_last_spot' do
    subject { spot.distance_from_last_spot }

    context 'when there is no last spot' do
      it { expect(subject).to be_nil }
    end

    context 'at the same spot spot' do
      let!(:last_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.3240, 34.0937] }, user: user, image: image, game: game) }
      it { expect(subject).to eq(0.0) }
    end

    context 'with a farther away last spot' do
      let!(:last_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.1111, 34.1111] }, user: user, image: image,  game: game) }
      it { expect(subject).to be_within(0.00001).of(0.21361) }
    end
  end

  describe '.near' do
    let(:point) { RGeo::GeoJSON.decode({ 'type' => 'Point', 'coordinates' => [-118.0, 34.0] }) }
    subject { Spot.near(point) }
    context 'with some spots at various distances' do
      let!(:near_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.1111, 34.1111] }, user: user, image: image,  game: game) }
      let!(:far_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.2222, 34.2222] }, user: user, image: image,  game: game) }
      let!(:mid_way_spot) { Spot.create!(location: { type: 'Point', coordinates: [-118.2222, 34.1111] }, user: user, image: image,  game: game) }
      it 'orders spot by distance' do
        expect(subject).to eq([near_spot, mid_way_spot, far_spot])
      end
    end
  end

  describe '.current.near' do
    let(:my_location) { RGeo::GeoJSON.decode({ 'type' => 'Point', 'coordinates' => [-118.0, 34.0] }) }
    let(:nearby) { { 'type' => 'Point', 'coordinates' => [-118.1, 34.1] } }
    let(:far_away) { { 'type' => 'Point', 'coordinates' => [-18.0, 4.0] } }
    let(:some_location) { far_away }

    context 'with some spots' do
      let!(:previous_spot) { FactoryGirl.create(:spot, location: nearby, user: user) }
      let!(:close_spot) { FactoryGirl.create(:spot, location: some_location, game: previous_spot.game, user: user) }
      let!(:far_spot) { FactoryGirl.create(:spot, location: far_away, user: user) }

      it 'returns the latest spots for each game ordered by distance' do
        expect(Spot.current.near(my_location)).to eq([close_spot, far_spot])
      end
    end

    context 'with a limit' do
      let!(:close_old_spot) { FactoryGirl.create(:spot, location: nearby, created_at: 5.days.ago) }
      let!(:close_new_spot) { FactoryGirl.create(:spot, location: nearby) }
      let!(:far_new_spot) { FactoryGirl.create(:spot, location: far_away) }

      it 'includes only the closest spots' do
        spots = Spot.current.near(my_location).limit(2)
        expect(spots.length).to eq(2)
        expect(spots).to include(close_new_spot)
        expect(spots).to include(close_old_spot)
        expect(spots).not_to include(far_new_spot)
      end
    end
  end
end
