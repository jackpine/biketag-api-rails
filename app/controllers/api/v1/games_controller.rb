class Api::V1::GamesController < Api::BaseController

  LA_LOCATION = RGeo::GeoJSON.decode({ 'type' => 'Point', 'coordinates' => [-118.2439080254345, 34.0546605969165] })

  def current_spot
    game = Game.find(params[:id])
    @spot = game.current_spot
    respond_to do |format|
      format.json
    end
  end


  # get current spots closest to location
  def current_spots

    if current_spots_params[:filter] && current_spots_params[:filter][:location]
      location = RGeo::GeoJSON.decode(current_spots_params[:filter][:location])
    end
    # assign default location (LA City Hall) if one couldn't be deciphered from the params.
    location ||= LA_LOCATION

    limit = current_spots_params[:limit] || 20

    @spots = Spot.current.near(location).limit(limit).includes(:guesses, :user, :game)

    respond_to do |format|
      format.json
    end
  end

  def index
    @games = Game.all.includes(spots: [:user, :game], guesses: [:user, :game])
    @spots = (@games.map &:spots).flatten
    @guesses = (@games.map &:guesses).flatten
    respond_to do |format|
      format.json
    end
  end

  def show
    @game = Game.find(params[:id])
    @spots = @game.spots.includes(:user, guesses: :user)
    @guesses = @game.guesses.includes(:user, :game,  spot: :user)
    respond_to do |format|
      format.json
    end
  end

  private

  def current_spots_params
    params.permit(:limit, filter: { location: [:type, coordinates: []] }).to_h
  end

end
