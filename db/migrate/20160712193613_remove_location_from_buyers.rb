class RemoveLocationFromBuyers < ActiveRecord::Migration
  def change
    remove_column :buyers, :location, :integer
  end
end
