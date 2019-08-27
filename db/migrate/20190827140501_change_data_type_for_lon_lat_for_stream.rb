class ChangeDataTypeForLonLatForStream < ActiveRecord::Migration[5.2]
  def change
    change_column :streams, :lon, :float, using: "lon::double precision"
    change_column :streams, :lat, :float, using: "lat::double precision"
  end
end
