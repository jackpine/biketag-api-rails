class Api::V1::GuessesController < Api::BaseController

  def create
    spot = Spot.find(guess_params[:spot_id])
    @guess = spot.guesses.create!(guess_params)

    respond_to do |format|
      format.json { render :show }
    end
  end

  def index
    @guesses = Guess.all
    respond_to do |format|
      format.json { render :index }
    end
  end

  def show
    @guess = Guess.find(params[:id])
    respond_to do |format|
      format.json { render :show }
    end
  end

  private

  def guess_params
    params.require(:guess).permit(:spot_id, location: [ :type, coordinates: [] ])
  end

end
