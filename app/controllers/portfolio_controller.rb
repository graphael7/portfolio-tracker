class PortfolioController < ApplicationController

  def show
    @user = User.find(params[:id])
    @portfolio = {name: "#{@user.first_name} #{@user.last_name}", stocks: []}
    @portfolio_pnl = 0

    @user.owned_stocks.each do |owned_stock|
      ticker = owned_stock.stock.ticker
      @data_from_api = StockQuote::Stock.quote(ticker)

      @stock_data = {}
      @stock_data[:stock_id] = owned_stock.id
      @stock_data[:ticker] = owned_stock.stock.ticker
      @stock_data[:company_name] = @data_from_api.name
      @stock_data[:shares_owned] = owned_stock.shares
      @stock_data[:original_price] = owned_stock.original_price
      @stock_data[:original_value] = (@stock_data[:shares_owned] * @stock_data[:original_price])
      @stock_data[:current_price] = (@data_from_api.last_trade_price_only)
      @stock_data[:current_value] = (@stock_data[:shares_owned] * @data_from_api.last_trade_price_only)
      @stock_data[:current_pnl] = (@stock_data[:current_value] - @stock_data[:original_value])
      @portfolio_pnl += @stock_data[:current_pnl]
      @portfolio[:stocks] << @stock_data
    end

    @portfolio[:portfolio_pnl] = @portfolio_pnl

    render json: @portfolio
  end
end
