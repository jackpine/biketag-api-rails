class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :notification_token, limit: 255, null: false
      t.references :user, null: false, index: true
      t.boolean :active, default: true, index: true

      t.timestamps
    end
    add_index :devices, :notification_token, unique: true
  end
end
