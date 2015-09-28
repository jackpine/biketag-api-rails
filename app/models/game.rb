class Game < ActiveRecord::Base
  has_many :spots
  has_many :guesses

  def current_spot
    spots.last
  end

  def current_spot_id
    if current_spot
      current_spot.id
    else
      nil
    end
  end

  def name
    "Game #{id}"
  end
end
