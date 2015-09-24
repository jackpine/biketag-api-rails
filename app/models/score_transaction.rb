class ScoreTransaction < ActiveRecord::Base

  belongs_to :user
  validates_presence_of  :user, :amount, :description
  validate :user_can_afford

  after_save do
    self.user.compute_score
  end

  after_destroy do
    self.user.compute_score
  end

  module ScoreAmounts
    CORRECT_GUESS = 10
    NEW_USER = 50
    NEW_GAME = -25
  end

  def self.credit_for_correct_guess(guess)
    description = "Correctly guessed #{guess.spot.user.name}'s spot (spot: #{guess.spot.id}, guess: #{guess.id})"
    self.create!(user: guess.user, amount: ScoreAmounts::CORRECT_GUESS, description: description)
  end

  def self.credit_for_new_user(user)
    description = 'Initial points'
    self.create!(user: user, amount: ScoreAmounts::NEW_USER, description: description)
  end

  def self.debit_for_new_game(spot)
    description = "Started new game with spot: #{spot.id}"
    self.create!(user: spot.user, amount: ScoreAmounts::NEW_GAME, description: description)
  end

  def user_can_afford
    return unless user && amount.kind_of?(Numeric)

    if (user.score + amount) < 0
      errors.add(:amount, "is more than user has")
    end
  end
end
