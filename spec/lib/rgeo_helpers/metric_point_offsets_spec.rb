require 'rails_helper'

describe RGeoHelpers::MetricPointOffsets do

  let(:original_point) { RGeo::GeoJSON.decode({"type"=>"Point", "coordinates"=>[-118.281617, 34.086588]}) }

  describe ".offset" do
    it 'accurately offsets a point in meters' do
      a = RGeoHelpers::MetricPointOffsets.offset(original_point, by_x_meters: 0, by_y_meters: 0)
      b = RGeoHelpers::MetricPointOffsets.offset(original_point, by_x_meters: 100, by_y_meters: 0)
      c = RGeoHelpers::MetricPointOffsets.offset(original_point, by_x_meters: 0, by_y_meters: 100)
      expect(a.distance(a)).to eq(0)
      expect(original_point.distance(a)).to be_within(0.01).of(0)
      expect(a.distance(b)).to be_within(0.01).of(100)
      expect(a.distance(c)).to be_within(0.01).of(100)
      expect(b.distance(c)).to be_within(0.01).of(Math.sqrt(20000))
    end

    it 'should fail when given the wrong args' do
      expect {
        RGeoHelpers::MetricPointOffsets.offset(original_point, x: 0, y: 0)
      }.to raise_error(ArgumentError)

      expect {
        RGeoHelpers::MetricPointOffsets.offset(original_point)
      }.to raise_error(ArgumentError)
    end
  end

  describe ".distance_in_meters" do
    let(:some_other_point) { RGeo::GeoJSON.decode({"type"=>"Point", "coordinates"=>[-118.8376, 34.1706]}) }

    it 'accurately measures the distance of two points in meters' do
      a = RGeoHelpers::MetricPointOffsets.offset(original_point, by_x_meters: 0, by_y_meters: 0)
      b = RGeoHelpers::MetricPointOffsets.offset(original_point, by_x_meters: 100, by_y_meters: 0)
      c = RGeoHelpers::MetricPointOffsets.offset(original_point, by_x_meters: 0, by_y_meters: 100)

      expect(RGeoHelpers::MetricPointOffsets.distance_in_meters(original_point, a)).to be_within(0.01).of(0)
      expect(RGeoHelpers::MetricPointOffsets.distance_in_meters(original_point, b)).to be_within(0.01).of(100)
      expect(RGeoHelpers::MetricPointOffsets.distance_in_meters(original_point, c)).to be_within(0.01).of(100)
      # rough straightline distance from LA to Thousand Oaks ~63km.
      expect(RGeoHelpers::MetricPointOffsets.distance_in_meters(original_point, some_other_point)).to be_within(1).of(62914)
    end
  end
end
