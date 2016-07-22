class AddFarmIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :farm_id, :integer
  end
end
