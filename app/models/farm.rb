class Farm < User
  has_many :products
  has_and_belongs_to_many :distributors
  has_and_belongs_to_many :buyers
end
