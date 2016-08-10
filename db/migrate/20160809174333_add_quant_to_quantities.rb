class AddQuantToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :quant, :integer
  end
end
