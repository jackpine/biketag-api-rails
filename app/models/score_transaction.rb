class ScoreTransaction < ActiveRecord::Base

  belongs_to :user
  validates_presence_of  :user, :amount, :description

  after_save do
    self.user.compute_score
  end

  module ScoreAmounts
    CORRECT_GUESS = 10
  end

  def self.create_for_guess(guess)
    description = "Correctly guessed #{guess.spot.user.name}'s spot (spot: #{guess.spot.id}, guess: #{guess.id})"
    self.create!(user: guess.user, amount: ScoreAmounts::CORRECT_GUESS, description: description)
  end
end
