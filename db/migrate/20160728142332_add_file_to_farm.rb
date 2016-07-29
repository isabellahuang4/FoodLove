class AddFileToFarm < ActiveRecord::Migration
  def change
    add_column :farms, :file, :string
  end
end
