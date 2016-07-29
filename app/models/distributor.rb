class Distributor < User
  has_and_belongs_to_many :farms
  has_and_belongs_to_many :buyers
  has_and_belongs_to_many :orders
end
