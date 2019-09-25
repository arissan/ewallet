class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :name
      t.float :balance, :default => 0.00
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
