module RGeoHelpers
  module MetricPointOffsets
    def self.offset(point, by_x_meters:, by_y_meters:)
      # Lifted from http://seamusabshere.github.io/2014/07/10/how-to-move-a-point-in-rgeo/
      wgs84 = RGeo::Geographic.simple_mercator_factory.point(point.x, point.y)
      wgs84_factory = wgs84.factory
      webmercator = wgs84_factory.project wgs84
      webmercator_factory = webmercator.factory
      webmercator_moved = webmercator_factory.point(webmercator.x + by_x_meters, webmercator.y + by_y_meters)
      wgs84_factory.unproject webmercator_moved
    end

    def self.distance_in_meters(point_1, point_2)
      # Lifted from http://seamusabshere.github.io/2014/07/10/how-to-move-a-point-in-rgeo/
      wgs84 = RGeo::Geographic.simple_mercator_factory.point(point_1.x, point_1.y)
      wgs84_factory = wgs84.factory
      webmercator_1 = wgs84_factory.project wgs84

      wgs84_2 = RGeo::Geographic.simple_mercator_factory.point(point_2.x, point_2.y)
      wgs84_factory_2 = wgs84_2.factory
      webmercator_2 = wgs84_factory_2.project wgs84_2

      webmercator_1.distance(webmercator_2)
    end
  end
end
