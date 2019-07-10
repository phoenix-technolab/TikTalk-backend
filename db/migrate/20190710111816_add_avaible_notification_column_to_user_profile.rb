class AddAvaibleNotificationColumnToUserProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :notifications, :json, default: { pause_all: false,
                                                            messages: true,
                                                            new_matches: true,
                                                            like_you: true,
                                                            message_in_private_room: true,
                                                            super_like: true }
  end
end
