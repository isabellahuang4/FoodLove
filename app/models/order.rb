class Order < ActiveRecord::Base
  belongs_to :buyer
  has_and_belongs_to_many :products
  has_and_belongs_to_many :farms
  has_and_belongs_to_many :distributors

  def to_s
    self.name
  end

  def total_price
    @p = BigDecimal.new(0)
    products.each do |pro|
      @p = @p+pro.price
    end
    return @p
  end

end
