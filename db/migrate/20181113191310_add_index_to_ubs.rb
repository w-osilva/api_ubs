class AddIndexToUbs < ActiveRecord::Migration[5.2]
  def change
    add_index :ubs, [:name, :address, :city]
  end
end
