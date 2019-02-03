class AddCalculatedColumnsToDayRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :day_records, :calculated_hours, :integer
    add_column :day_records, :time_records_odd, :boolean
  end
end
