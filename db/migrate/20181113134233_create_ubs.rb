class CreateUbs < ActiveRecord::Migration[5.2]
  def change
    create_table :ubs do |t|
      t.string :name, null: false
      t.string :address
      t.string :city
      t.string :phone
      t.text :scores
      t.text :geocode

      t.timestamps
    end
    add_index :ubs, :scores, type: :fulltext
    add_index :ubs, :geocode, type: :fulltext
    add_index :ubs, [:name, :address, :city], unique: true
  end
end
