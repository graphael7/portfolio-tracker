class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owned_stocks

  def set_new_authentication_token
    self.update_attributes(authentication_token: generate_authentication_token)
  end

  def remove_authentication_token
    self.update_attributes(authentication_token: nil)
  end

  def generate_portfolio
    # Generates a hash representing a user's portfolio
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
    portfolio
  end

  def generate_portfolio_history

    # Returns a hash representing a user's portfolio history, since their first buy, structured like this:
    # [
    #   { date: Date,
    #     daily_total_value: that day's total portfolio value,
    #     daily_total_pnl: that day's total profits & losses,
    #     portfolio: [
    #       {ticker: stock ticker name, shares: number of shares in a buy, original_price: price of stock when bought}
    #     ]
    #   }
    # ]

    number_of_days_since_first_buy = (Date.today - self.owned_stocks.first.created_at.to_date).to_i
    historical_portfolio = []

    while number_of_days_since_first_buy > 0
      date = Date.today - number_of_days_since_first_buy

      # Only computes values if stock market was open that day
      if trading_day?(date)
        # initialize hash for each day
        daily = {}
        daily[:date] = date
        daily[:portfolio] = []
        daily[:daily_total_value] = 0
        daily[:daily_total_pnl] = 0

        # Iterate through that day's portfolio and generate historical data
        buys = OwnedStock.where("DATE(created_at) < ?", date)
        buys.each do |buy|
          daily[:portfolio] << {ticker: buy.stock.ticker, shares: buy.shares, original_price: buy.original_price}
          stock_historical_value = StockQuote::Stock.history(buy.stock.ticker, date, date).first.adj_close
          daily[:daily_total_value] += (stock_historical_value * buy.shares)
          daily[:daily_total_pnl] += (daily[:daily_total_value] - (buy.shares * buy.original_price))
          historical_portfolio << daily
        end
      end
      number_of_days_since_first_buy -= 1
    end
    historical_portfolio
  end

  def trading_day?(date)
    StockQuote::Stock.history("FB",date,date).class == Array
  end

   private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
