class CreateUserStreams < ActiveRecord::Migration[5.2]
  def change
    create_table :user_streams do |t|
      t.belongs_to :stream
      t.belongs_to :participant
      t.timestamps
    end
  end
end
