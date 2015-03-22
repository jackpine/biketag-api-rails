class Api::V1::GuessesController < ApplicationController

  def create
    spot = Spot.find(params[:spot_id])
    @guess = spot.guesses.create!(guess_params)

    respond_to do |format|
      format.json { render :show }
    end
  end

  private

  def guess_params
    params.require(:guess).permit(location: [ :type, coordinates: [] ])
  end

end
