class Api::V1::GamesController < Api::BaseController

  def current_spot
    game = Game.find(params[:id])
    @spot = game.current_spot
    respond_to do |format|
      format.json
    end
  end


  # get current spots closest to location
  def current_spots

    if params[:filter] && params[:filter][:location]
      location = RGeo::GeoJSON.decode(params[:filter][:location])
    end

    # assign default location (LA City Hall) if one couldn't be deciphered from the params.
    if location.nil?
      location = RGeo::GeoJSON.decode({ 'type' => 'Point', 'coordinates' => [-118.2439080254345, 34.0546605969165] })
    end

    limit = params[:limit] || 20

    @spots = Spot.current.near(location).limit(limit)

    respond_to do |format|
      format.json
    end
  end

  def index
    @games = Game.all
    respond_to do |format|
      format.json
    end
  end

  def show
    @game = Game.find(params[:id])
    respond_to do |format|
      format.json
    end
  end

end
