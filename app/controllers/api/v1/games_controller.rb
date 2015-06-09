class Api::V1::GamesController < Api::BaseController

  def current_spot
    game = Game.find(params[:id])
    @spot = game.current_spot
    respond_to do |format|
      format.json
    end
  end

  def index
    @games = Game.all
    respond_to do |format|
      format.json { render :index }
    end
  end

  def show
    @game = Game.find(params[:id])
    respond_to do |format|
      format.json { render :show }
    end
  end

end
