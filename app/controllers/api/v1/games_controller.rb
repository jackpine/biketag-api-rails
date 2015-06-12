class Api::V1::GamesController < Api::BaseController

  def current_spot
    game = Game.find(params[:id])
    @spot = game.current_spot
    respond_to do |format|
      format.json
    end
  end

  def current_spots
    @spots = Game.current_spots
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
