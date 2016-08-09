class CreateOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.belongs_to :product, index: true
      t.belongs_to :buyer, index: true
    end
  end
end
