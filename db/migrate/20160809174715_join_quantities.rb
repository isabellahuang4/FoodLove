class JoinQuantities < ActiveRecord::Migration
  def change
    change_table :quantities do |t|
      t.belongs_to :order, index: true
      t.belongs_to :product, index: true
    end
  end
end
