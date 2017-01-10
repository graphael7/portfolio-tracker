class StockController < ApplicationController

  def show
    @stock = Stock.find(params[:id])
    @stock_profile = @stock.generate_stock
    render json: @stock_profile
  end

  def create
  	@user = User.find(params[:user_id])
  	@stock = Stock.find(params[:id])
  	# need a conditional statement to find out if i need to buy or sell
  	# if this is a buy do this
  	buy_stock = OwnedStock.new(user_id:@user.id, stock_id:@stock.id, shares: params[:buy], original_price:@stock.current_price_of_stock)
  	# if this is a sell do this
  	sell_stock = OwnedStock.new(user_id:@user.id, stock_id:@stock.id, shares: params[:sell], original_price:@stock.current_price_of_stock)


  end
end
