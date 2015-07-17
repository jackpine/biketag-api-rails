require 'rails_helper'

describe Api::V1::GamesController do
  before do
    stub_authentication!
  end

  describe '#current_spots' do
    context 'specifying location' do
      it 'returns spots near location' do
        location_geo_json = {'type'=>'Point', 'coordinates'=>[-118.3004, 34.1186]}
        location = RGeo::GeoJSON.decode(location_geo_json)
        expect(Spot).to receive(:near).with(location).and_return(Spot.all)

        get :current_spots, { filter: { location: location_geo_json }, format: 'json' }

        expect(response).to be_success
        expect(assigns(:spots)).to_not be_nil
      end
    end

    context 'without specifying location' do
      it 'returns some spots' do
        expect(Spot).not_to receive(:near)

        get :current_spots, { format: 'json' }

        expect(response).to be_success
        expect(assigns(:spots)).to_not be_nil
      end
    end
  end
end
