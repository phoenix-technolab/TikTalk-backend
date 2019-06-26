class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :user, foreign_key: true
      t.string :image
      t.timestamps
    end
  end
end
