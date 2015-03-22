class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.st_point :location, srid: 4326, null: false
      t.belongs_to :spot, null: false
      t.boolean :correct, null: false
      t.string :reason
      t.timestamps
    end
    add_foreign_key :guesses, :spots
    add_index :guesses, :location
    add_index :guesses, :spot_id
  end
end
