class CreateTransactionHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_histories do |t|
      t.decimal :amount, :default => 0.00
      t.integer :from_id, null: true
      t.integer :to_id, null: true
      t.string  :type
      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
