class AddPlacedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :placed, :datetime
  end
end
