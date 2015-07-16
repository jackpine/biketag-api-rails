class AddImageToGuess < ActiveRecord::Migration
  def change
    change_table :guesses do |t|
      t.attachment :image
    end
  end
end
