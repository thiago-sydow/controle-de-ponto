class CreateTimeRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :time_records do |t|
      t.datetime :time, null: false
      t.references :day_record
      t.timestamps null: false
    end
  end
end
