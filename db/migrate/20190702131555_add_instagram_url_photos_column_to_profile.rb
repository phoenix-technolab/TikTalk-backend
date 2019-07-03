class AddInstagramUrlPhotosColumnToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :instagram_photos_url, :string, default: [], array:true
  end
end
