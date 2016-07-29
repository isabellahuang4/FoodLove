
class AddLatAndLngToUsers < ActiveRecord::Migration
  change_table :users do |t|
    t.decimal :lat, :precision => 15, :scale => 10
    t.decimal :lng, :precision => 15, :scale => 10
  end
end
