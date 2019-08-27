class CreateStreams < ActiveRecord::Migration[5.2]
  def change
    create_table :streams do |t|
      t.string :lon
      t.string :lat
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
