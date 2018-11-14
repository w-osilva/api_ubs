class CreateGeocodes < ActiveRecord::Migration[5.2]
  def change
    create_table :geocodes do |t|
      t.decimal :lat, precision: 15, scale: 11
      t.decimal :long, precision: 15, scale: 11

      t.timestamps
    end
  end
end
