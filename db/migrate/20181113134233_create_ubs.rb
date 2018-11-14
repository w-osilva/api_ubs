class CreateUbs < ActiveRecord::Migration[5.2]
  def change
    create_table :ubs do |t|
      t.string :name, null: false
      t.string :address
      t.string :city
      t.string :phone
      t.references :geocode, foreign_key: true

      t.timestamps
    end
  end
end
