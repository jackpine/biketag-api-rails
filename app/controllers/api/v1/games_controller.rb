class Api::V1::GamesController < ApplicationController

  def current_spot
    @spot = Spot.current_spot
    respond_to do |format|
      format.json
    end
  end

end
