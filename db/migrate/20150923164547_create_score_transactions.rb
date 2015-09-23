class CreateScoreTransactions < ActiveRecord::Migration
  def change
    create_table :score_transactions do |t|
      t.belongs_to :user, null: false, index: true
      t.integer :amount, null: false
      t.string :description, null: false
      t.timestamps null: false
    end
    add_foreign_key 'score_transactions', 'users'

    add_column :users, :score, :integer, default: 0, null: false
  end
end
