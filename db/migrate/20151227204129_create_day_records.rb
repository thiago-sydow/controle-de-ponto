class CreateDayRecords < ActiveRecord::Migration
  def change
    create_table :day_records do |t|
      t.date :reference_date, null: false
      t.text :observations
      t.string :work_day
      t.string :missed_day
      t.string :medical_certificate

      t.references :account

      t.timestamps null: false
    end
  end
end
