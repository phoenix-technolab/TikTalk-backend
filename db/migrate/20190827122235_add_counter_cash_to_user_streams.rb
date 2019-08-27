class AddCounterCashToUserStreams < ActiveRecord::Migration[5.2]
  def change
    add_column :streams, :participants_count, :integer, default: 0
  end
end
