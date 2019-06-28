class AddLookingForOptionsToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.column :prefer_gender_male, :boolean, default: false
      t.column :prefer_gender_female, :boolean, default: true
      t.column :prefer_min_age, :integer
      t.column :prefer_max_age, :integer
      t.column :prefer_location_distance, :integer
      t.column :is_show_in_app, :boolean, default: true
      t.column :is_show_in_places, :boolean, default: true
    end

  end
end
