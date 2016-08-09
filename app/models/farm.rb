class Farm < User
  has_many :products
  has_and_belongs_to_many :distributors
  has_and_belongs_to_many :buyers
  has_and_belongs_to_many :orders
  has_many :notifications

  mount_uploader :file, FileUploader

  accepts_nested_attributes_for :products, :allow_destroy => true

  scope :name_search, -> (name) {where("name like ? or location like ?", "%#{name}%", "%#{name}%")}
  scope :location_search, -> (loc) {where("location like ?", "%#{loc}")}
  
  def add_order(order,f_id)
    @farm = Farm.find(f_id)
    @farm.orders.push(order)
  end

  def file_changed?
  end

end
