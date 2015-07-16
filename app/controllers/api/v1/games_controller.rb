class Api::V1::GamesController < Api::BaseController

  def current_spot
    game = Game.find(params[:id])
    @spot = game.current_spot
    respond_to do |format|
      format.json
    end
  end

  def current_spots
    @spots = Spot.current(limit: 20)

    #sort by location if available
    if params[:filter] && params[:filter][:location]
      location = RGeo::GeoJSON.decode(params[:order][:location])
      spot_ids = @spots.map &:id
      @spots = Spot.near(location).where(id: spot_ids)
    end

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
