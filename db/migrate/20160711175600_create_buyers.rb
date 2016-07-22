class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.integer :location

      t.timestamps null: false
    end
  end
end
