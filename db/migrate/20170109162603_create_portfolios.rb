class CreatePortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolios do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.integer :shares_owned
      t.float :original_price

      t.timestamps
    end
  end
end
