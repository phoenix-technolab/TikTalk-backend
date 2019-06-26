class AddIsAccountBlockedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_account_block, :boolean, default: false
  end
end
