class CreateClosures < ActiveRecord::Migration
  def change
    create_table :closures do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :account
      t.timestamps null: false
    end
  end
end
