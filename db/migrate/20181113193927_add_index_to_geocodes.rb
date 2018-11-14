class AddIndexToGeocodes < ActiveRecord::Migration[5.2]
  def change
    add_index :geocodes, [:lat, :long]
  end
end
