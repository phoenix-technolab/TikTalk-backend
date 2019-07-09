class AddTwilioUserIdToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :twilio_user_id, :string, default:""
  end
end
