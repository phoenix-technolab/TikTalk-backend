class AddLockerTypeLockerValueToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :locker_value, :string
    add_column :profiles, :locker_type, :int
  end
end
