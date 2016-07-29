class AddDistsToOrders < ActiveRecord::Migration
  def change
    add_column :orders_users, :distributor_id, :integer
    add_index "orders_users", ["distributor_id"], name: "index_distributors_orders_on_distributor_id"
  end
end
