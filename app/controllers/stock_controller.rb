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
    buyorsell = params[:position_type]

    if buyorsell = "buy"
  	   buysell_stock = OwnedStock.new(user_id:@user.id, stock_id:@stock.id, shares: params[:share_amount], original_price:@stock.current_price_of_stock)
  	else # if this is a sell do this
  	   buysell_stock = OwnedStock.new(user_id:@user.id, stock_id:@stock.id, shares: params[:share_amount], original_price:-(@stock.current_price_of_stock))
    end

    if buysell_stock.save
      render :json=>{:success=>true, :message=>"You have succesfully bought your stock"}
    else
      render :json => buysell_stock.errors
    end
  end
end
