class AddCurrentAccountToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_account_id, :integer
    add_index  :users, :current_account_id
  end
end
