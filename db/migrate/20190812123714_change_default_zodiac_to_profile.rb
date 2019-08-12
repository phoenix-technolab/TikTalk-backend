class ChangeDefaultZodiacToProfile < ActiveRecord::Migration[5.2]
  def change
    change_column :profiles, :zodiac, :int, default: 0, null: false
  end
end
