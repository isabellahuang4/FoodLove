class Product < ActiveRecord::Base
  belongs_to :farm
  has_and_belongs_to_many :orders
  monetize :price, :as => :price_cents

  scope :name_search, -> (name) {where("name like ?", "%#{name}%")}
  scope :category_search, -> (category) {where("category like ?", "%#{category}%")}
  scope :farm_search, -> (farm_name) { where farm_id: Farm.find_by(farm_name).id }
  scope :name_or_cat, -> (name_or_cat) {where("name like ? or category like ?", "%#{name_or_cat}%", "%#{name_or_cat}%")}

end
