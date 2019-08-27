# == Schema Information
#
# Table name: streams
#
#  id                 :bigint           not null, primary key
#  lon                :float
#  lat                :float
#  user_id            :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  participants_count :integer          default(0)
#

class Stream < ApplicationRecord
  belongs_to :user
  has_many :user_streams, dependent: :destroy
  has_many :participants, through: :user_streams, source: :participant

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lon

  ROOM_TWILIO_STATUSES = %W(ParticipantConnected ParticipantDisconnected RoomEnded)

  scope :nearby, lambda{|lat:, lon:| 
    within(1, :origin => [lat, lon])
  }

  scope :popularity, lambda{|by_popularity|
    where("participants_count >= 1")
  }
end
