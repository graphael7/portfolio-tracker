class StockController < ApplicationController

  def show
    @stock = Stock.find(params[:id])
    @stock_profile = @stock.generate_stock
    render json: @stock_profile
  end
end
