class AddCurrentAccountToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :current_account_id, :integer
    add_index  :users, :current_account_id
  end
end
