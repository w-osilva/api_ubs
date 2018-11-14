class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.integer :size, limit: 2
      t.integer :adaptation_for_seniors, limit: 2
      t.integer :medical_equipment, limit: 2
      t.integer :medicine, limit: 2
      t.references :ubs, foreign_key: true

      t.timestamps
    end
  end
end
