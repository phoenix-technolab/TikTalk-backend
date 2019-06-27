class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone_number
      t.string :code_country
      t.string :tokens, default: [], array: true
      t.boolean :is_verified, default: false
      t.string :name
      t.datetime :birth_date
      t.string :country
      t.string :city
      t.integer :gender

      t.timestamps
    end
  end
end
