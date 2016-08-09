class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :product, index: true
      t.belongs_to :buyer, index: true
    end
  end
end
