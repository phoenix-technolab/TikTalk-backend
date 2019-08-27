# == Schema Information
#
# Table name: streams
#
#  id                 :bigint           not null, primary key
#  lon                :string
#  lat                :string
#  user_id            :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  participants_count :integer          default(0)
#

class Stream < ApplicationRecord
  belongs_to :user
  has_many :user_streams, dependent: :destroy
  has_many :participants, through: :user_streams, source: :participant

  ROOM_TWILIO_STATUSES = %W(ParticipantConnected ParticipantDisconnected RoomEnded)
end
