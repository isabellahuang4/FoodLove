class RemoveLatFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lat, :decimal
  end
end
