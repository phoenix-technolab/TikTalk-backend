class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.column :prefer_gender_male, :boolean, default: false
      t.column :prefer_gender_female, :boolean, default: true
      t.column :prefer_min_age, :integer, default: 18
      t.column :prefer_max_age, :integer, default: 25
      t.column :prefer_location_distance, :integer, default: 10
      t.column :is_show_in_app, :boolean, default: true
      t.column :is_show_in_places, :boolean, default: true
      t.column :work, :string
      t.column :education, :string
      t.column :about_you, :string
      t.column :relationship, :integer, default: 0
      t.column :sexuality, :integer, default: 0
      t.column :height, :integer
      t.column :living, :integer, default: 0
      t.column :children, :integer, default: 0
      t.column :smoking, :integer, default: 0
      t.column :drinking, :integer, default: 0
      t.column :speak, :string, default: [], array: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
