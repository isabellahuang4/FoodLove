class RemoveLocationFromFarms < ActiveRecord::Migration
  def change
    remove_column :farms, :location, :integer
  end
end
