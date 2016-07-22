class CreateFarmsAndDistributors < ActiveRecord::Migration
  def change
    create_table :distributors_farms, id: false do |t|
      t.belongs_to :farm, index: true
      t.belongs_to :distributor, index: true
    end
  end
end
