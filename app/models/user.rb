class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :owned_stocks
  has_many :stock_tickers, through: :owned_stocks, source: :stock

  def generate_portfolio
    portfolio = {name: "#{self.first_name} #{self.last_name}",user_id: self.id, stocks: []}
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
      stock_data[:original_value] = (stock_data[:shares_owned] * stock_data[:original_price]).round(4)
      stock_data[:current_price] = (data_from_api.last_trade_price_only).round(4)
      stock_data[:current_value] = (stock_data[:shares_owned] * data_from_api.last_trade_price_only).round(4)
      stock_data[:current_pnl] = (stock_data[:current_value] - stock_data[:original_value]).round(4)

      portfolio_pnl += stock_data[:current_pnl]
      portfolio_cost_basis += stock_data[:original_value]
      portfolio_total_value += stock_data[:current_value]
      portfolio[:stocks] << stock_data
    end

    portfolio[:portfolio_pnl] = portfolio_pnl.round(4)
    portfolio[:portfolio_cost_basis] = portfolio_cost_basis.round(4)
    portfolio[:portfolio_total_value] = portfolio_total_value.round(4)
    portfolio[:history] = generate_portfolio_history
    portfolio
  end

  def generate_portfolio_history
    pnl_history = []
    number_of_days = (Date.today - self.owned_stocks.first.created_at.to_date).to_i
    historical_portfolio = []
    while number_of_days > 0
      date = Date.today - number_of_days
      if trading_day?(date)
        daily = {}
        daily[:date] = date
        daily[:portfolio] = []
        daily[:overall_value] = 0
        daily[:total_pnl] = 0
        buys = OwnedStock.where("DATE(created_at) < ?", date)
        buys.each do |buy|
          daily[:portfolio] << {ticker: buy.stock.ticker, shares: buy.shares, original_price: buy.original_price}
          stock_historical_value = StockQuote::Stock.history(buy.stock.ticker, date, date).first.adj_close
          daily[:overall_value] += (stock_historical_value * buy.shares)
          daily[:total_pnl] += (daily[:overall_value] - (buy.shares * buy.original_price))
          historical_portfolio << daily
        end
      end
      number_of_days -= 1
    end
    historical_portfolio
  end

  def trading_day?(date)
    StockQuote::Stock.history("FB",date,date).class == Array
  end
end
