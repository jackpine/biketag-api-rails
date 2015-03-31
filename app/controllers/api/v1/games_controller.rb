class Api::V1::GamesController < Api::BaseController

  def current_spot
    @spot = Spot.current_spot
    respond_to do |format|
      format.json
    end
  end

  def index
    @games = [1,2,3,4,5,6,7].map {|i| make_game(i) }
    respond_to do |format|
      format.json { render :index }
    end
  end

  def show
    @game = make_game(params[:id])
    respond_to do |format|
      format.json { render :show }
    end
  end

  def make_game(id)
    { id: id,
      name: "Game #{id}"
    }
  end

end
