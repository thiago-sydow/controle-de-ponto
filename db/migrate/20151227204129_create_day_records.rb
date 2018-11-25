class CreateDayRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :day_records do |t|
      t.date :reference_date, null: false
      t.text :observations
      t.integer :work_day, limit: 1
      t.integer :missed_day, limit: 1
      t.integer :medical_certificate, limit: 1

      t.references :account

      t.timestamps null: false
    end
  end
end
