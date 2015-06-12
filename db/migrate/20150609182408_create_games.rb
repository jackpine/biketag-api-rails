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
  end

  def down
    remove_column :spots, :game_id
    drop_table :games do |t|
      t.timestamps null: false
    end
  end
end
