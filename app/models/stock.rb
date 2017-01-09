class Stock < ApplicationRecord
  has_many :positions, class_name: OwnedStock
  has_many :owners, through: :positions, source: :user
end
