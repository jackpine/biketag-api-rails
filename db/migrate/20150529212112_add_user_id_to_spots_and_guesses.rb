class AddUserIdToSpotsAndGuesses < ActiveRecord::Migration
  def change
    add_reference :spots, :user, index: true, foreign_key: true, null: false, default: 1
    # remove default which was only for backfilling during migration
    change_column_default(:spots, :user_id, nil)
    add_foreign_key :spots, :users

    add_reference :guesses, :user, index: true, foreign_key: true, null: false, default: 1
    # remove default which was only for backfilling during migration
    change_column_default(:guesses, :user_id, nil)
    add_foreign_key :guesses, :users
  end
end
