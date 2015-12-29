class CreateTimeRecords < ActiveRecord::Migration
  def change
    create_table :time_records do |t|
      t.datetime :time, null: false
      t.references :day_record
      t.timestamps null: false
    end
  end
end
