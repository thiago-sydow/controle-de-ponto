class ChangeAccountsTableDefault < ActiveRecord::Migration[5.2]
  def up
    change_column_default :accounts, :preferences, from: '{}', to: {}
    execute "UPDATE accounts SET preferences = '{}'::jsonb WHERE preferences = '\"{}\"'"
  end

  def down
    change_column_default :accounts, :preferences, from: {}, to: '{}'
    execute "UPDATE accounts SET preferences = '\"{}\"' WHERE preferences = '{}'::jsonb"
  end
end
