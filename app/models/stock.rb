class Stock < ApplicationRecord
  has_many :positions, class_name: OwnedStock
  has_many :owners, through: :positions, source: :user

  validates :ticker, presence: true
  validates :ticker, uniqueness: true


  def generate_stock
    stock_data = {}
    data_from_api = StockQuote::Stock.quote(self.ticker)
    stock_data[:id] = self.id
    stock_data[:symbol] = (data_from_api.symbol)
    stock_data[:bid_realtime] = (data_from_api.bid_realtime)
    stock_data[:ask_realtime] = (data_from_api.ask_realtime)
    stock_data[:change_realtime] = (data_from_api.change_realtime)
    stock_data[:eps_estimate_current_year] = (data_from_api.eps_estimate_current_year)
    stock_data[:days_low] = (data_from_api.days_low)
    stock_data[:days_high] = (data_from_api.days_high)
    stock_data[:year_low] = (data_from_api.year_low)
    stock_data[:year_high] = (data_from_api.year_high)
    stock_data[:market_capitalization] = (data_from_api.market_capitalization)
    stock_data[:last_trade_price_only] = (data_from_api.last_trade_price_only)
    stock_data[:ebitda] = (data_from_api.ebitda)
    stock_data[:pe_ratio] = (data_from_api.pe_ratio)
    stock_data[:pe_ratio_realtime] = (data_from_api.pe_ratio_realtime)
    stock_data[:volume] = (data_from_api.volume)
    stock_data[:history] = StockQuote::Stock.history(self.ticker, 1.month.ago.to_datetime, Date.today)

    stock_data
  end

end
