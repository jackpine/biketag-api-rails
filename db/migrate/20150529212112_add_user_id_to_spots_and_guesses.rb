class AddUserIdToSpotsAndGuesses < ActiveRecord::Migration
  def change
    add_reference :guesses, :user, index: true, foreign_key: true, null: false
    add_reference :spots, :user, index: true, foreign_key: true, null: false
    add_foreign_key :guesses, :users
    add_foreign_key :spots, :users
  end
end
