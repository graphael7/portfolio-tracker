class OwnedStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :shares, presence: true
  validates :shares, numericality: {only_integer: true}
  validates :original_price, presence: true
  validates :original_price, numericality: {only_float: true}
end
