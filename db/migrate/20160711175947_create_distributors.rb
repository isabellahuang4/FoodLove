class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
      t.string :placeholder

      t.timestamps null: false
    end
  end
end
