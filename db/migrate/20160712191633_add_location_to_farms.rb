class AddLocationToFarms < ActiveRecord::Migration
  def change
    add_column :farms, :location, :integer
  end
end
