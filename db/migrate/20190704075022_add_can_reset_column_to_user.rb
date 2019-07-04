class AddCanResetColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :can_reset, :boolean, default: false
  end
end
