class CreateUsersAndOrders < ActiveRecord::Migration
  def change
    create_table :orders_users, id: false do |t|
      t.belongs_to :farm, index: true
      t.belongs_to :order, index: true
    end
  end
end
