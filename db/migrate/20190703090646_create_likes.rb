class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :like_dislikes do |t|
      t.references :user, foreign_key: true
      t.references :receiver, foreign_key: { to_table: :users }
      t.column :status, :integer, default: 0

      t.timestamps
    end
  end
end
