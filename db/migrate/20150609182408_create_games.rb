class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.timestamps null: false
    end
    Game.create!

    add_reference :spots, :game, index: true, foreign_key: true, null: false, default: 1
    # remove default which was only for backfilling during migration
    change_column_default(:spots, :game_id, nil)
    add_foreign_key :spots, :games

    add_reference :guesses, :game, index: true, foreign_key: true, null: false, default: 1
    # remove default which was only for backfilling during migration
    change_column_default(:guesses, :game_id, nil)
    add_foreign_key :guesses, :games
  end

  def down
    drop_table :games do |t|
      t.timestamps null: false
    end

    remove_column :spots, :game_id
    remove_column :guesses, :game_id
  end
end
