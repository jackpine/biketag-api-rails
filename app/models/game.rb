class Game < ActiveRecord::Base
  has_many :spots
  has_many :guesses
end
