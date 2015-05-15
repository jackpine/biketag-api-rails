class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :client_id, null: false
      t.integer :user_id, index: true, foreign_key: true, null: false
      t.string :secret, null: false

      t.timestamps null: false
    end
    add_index :api_keys, :client_id, unique: true
    add_index :api_keys, :secret, unique: true
    add_foreign_key :api_keys, :users
  end
end
