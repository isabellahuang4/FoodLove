class RemoveNameFromFarms < ActiveRecord::Migration
  def change
    remove_column :farms, :name, :string
  end
end
