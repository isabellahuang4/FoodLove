class CreateUsersAndUsers < ActiveRecord::Migration
  def change
    create_table :users_users do |t|
      t.belongs_to :farm, index: true
      t.belongs_to :distributor, index: true
    end
  end
end
