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
      # assign default location (LA City Hall) if one couldn't be found in the params.
      if location.nil?
        location = RGeo::GeoJSON.decode('{"type":"Point","coordinates":[34.0546605969165, -118.2439080254345]}')
      end
    end

    @spots = Spot.current_and_near(location).limit(20)

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
