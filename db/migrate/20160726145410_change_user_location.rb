class ChangeUserLocation < ActiveRecord::Migration
  def change
    change_column :users, :location, :text
  end
end
