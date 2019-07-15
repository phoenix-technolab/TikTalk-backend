class DeleteColumnIsBlockFromTableBlockUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :block_users, :is_block
  end
end
