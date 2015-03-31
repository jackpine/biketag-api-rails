class Api::V1::GuessesController < Api::BaseController

  def create
    @guess = Guess.create!(guess_params)

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
    p = params.require(:guess)
    # Is this the right way to require spot_id without descending
    # the scope which "permit" operates?
    p.require(:spot_id)

    p.permit(location: [ :type, coordinates: [] ])
  end

end
