class CreateBlockUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :block_users do |t|
      t.references :user, foreign_key: true
      t.references :receiver, foreign_key: { to_table: :users }
      t.column :is_block, :boolean, default: false
      t.timestamps
    end
  end
end
