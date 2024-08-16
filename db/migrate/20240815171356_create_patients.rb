class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.text :medical_history
      t.string :sync_status
      t.datetime :timestamp

      t.timestamps
    end
  end
end
