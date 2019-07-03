class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.column :report_type, :integer
      t.references :receiver, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
