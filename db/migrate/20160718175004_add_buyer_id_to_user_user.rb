class AddBuyerIdToUserUser < ActiveRecord::Migration
  def change
    change_table :users_users do |t|
      t.belongs_to :buyer, index: true
    end
  end
end
