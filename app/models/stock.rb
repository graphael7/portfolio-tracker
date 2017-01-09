class Stock < ApplicationRecord
  has_many :positions, class_name: OwnedStock
  has_many :owners, through: :positions, source: :user

  validates :ticker, presence: true
  validates :ticker, uniqueness: true


  def generate_stock
    stock_data = {}
    data_from_api = StockQuote::Stock.quote(self.ticker)
    stock_data[:symbol] = (data_from_api.symbol)
    stock_data[:bid_realtime] = (data_from_api.bid_realtime)
    stock_data[:ask_realtime] = (data_from_api.ask_realtime)
    stock_data[:change_realtime] = (data_from_api.change_realtime)
    stock_data[:eps_estimate_currentyear] = (data_from_api.eps_estimate_currentyear)
    stock_data[:days_low] = (data_from_api.days_low)
    
    stock_data
  end

end
