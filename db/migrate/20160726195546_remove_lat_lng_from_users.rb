class RemoveLatLngFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lat, :decimal
    remove_column :users, :lng, :decimal
  end
end
