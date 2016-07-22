class RemovePlaceholderFromDistributors < ActiveRecord::Migration
  def change
    remove_column :distributors, :placeholder, :string
  end
end
