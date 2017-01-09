class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owned_stocks
  has_many :stock_tickers, through: :owned_stocks, source: :stock

  def generate_portfolio
    portfolio = {name: "#{self.first_name} #{self.last_name}", stocks: []}
    portfolio_pnl = 0
    portfolio_cost_basis = 0
    portfolio_total_value = 0

    self.owned_stocks.each do |owned_stock|
      ticker = owned_stock.stock.ticker
      data_from_api = StockQuote::Stock.quote(ticker)

      stock_data = {}

      stock_data[:stock_id] = owned_stock.id
      stock_data[:ticker] = owned_stock.stock.ticker
      stock_data[:company_name] = data_from_api.name
      stock_data[:shares_owned] = owned_stock.shares
      stock_data[:original_price] = owned_stock.original_price
      stock_data[:original_value] = (stock_data[:shares_owned] * stock_data[:original_price])
      stock_data[:current_price] = (data_from_api.last_trade_price_only)
      stock_data[:current_value] = (stock_data[:shares_owned] * data_from_api.last_trade_price_only)
      stock_data[:current_pnl] = (stock_data[:current_value] - stock_data[:original_value])

      portfolio_pnl += stock_data[:current_pnl]
      portfolio_cost_basis += stock_data[:original_value]
      portfolio_total_value += stock_data[:current_value]
      portfolio[:stocks] << stock_data
    end

    portfolio[:portfolio_pnl] = portfolio_pnl
    portfolio[:portfolio_cost_basis] = portfolio_cost_basis
    portfolio[:portfolio_total_value] = portfolio_total_value
    portfolio
  end
end
