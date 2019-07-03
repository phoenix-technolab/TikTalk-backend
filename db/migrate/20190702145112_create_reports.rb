class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.column :report_type, :integer
      t.column :receiver_id, :integer
      t.timestamps
    end
  end
end
