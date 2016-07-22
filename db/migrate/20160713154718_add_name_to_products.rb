class AddNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :name, :string
    add_column :products, :unit, :string
    add_column :products, :price, :decimal, precision: 5, scale: 2
    add_column :products, :quantity, :integer
    add_column :products, :category, :string
    add_column :products, :available, :boolean
    add_column :products, :feature, :boolean
    add_column :products, :description, :text
    add_column :products, :notes, :text
  end
end
