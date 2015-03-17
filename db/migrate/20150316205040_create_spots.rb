class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.st_point :location, srid: 4326, null: false
      t.attachment :image, null: false
      t.timestamps
    end
    add_index :spots, :location
  end
end
