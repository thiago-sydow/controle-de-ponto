class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :type #STI
      t.string :name, null: false
      t.integer :workload, null: false, default: 28800 #8.hours
      t.references :user
      t.jsonb :preferences, null: false, default: '{}'
      t.timestamps null: false
    end

    add_index  :accounts, :preferences, using: :gin
  end
end
