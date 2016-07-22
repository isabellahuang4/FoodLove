class Buyer < User
  has_many :orders
  has_and_belongs_to_many :farms
  has_and_belongs_to_many :distributors  
end
