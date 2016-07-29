class AddFarmIdToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :farm_id, :integer
  end
end
