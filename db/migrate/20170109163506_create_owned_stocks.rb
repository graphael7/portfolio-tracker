class CreateOwnedStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :owned_stocks do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.integer :shares
      t.float :original_price

      t.timestamps
    end
  end
end
