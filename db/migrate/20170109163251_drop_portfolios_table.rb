class DropPortfoliosTable < ActiveRecord::Migration[5.0]
  def change
    def up
      drop_table :portfolios
    end
  end
end
