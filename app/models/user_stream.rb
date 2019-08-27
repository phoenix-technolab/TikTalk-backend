# == Schema Information
#
# Table name: user_streams
#
#  id             :bigint           not null, primary key
#  stream_id      :bigint
#  participant_id :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class UserStream < ApplicationRecord
  belongs_to :stream, counter_cache: :participants_count
  belongs_to :participant, class_name: 'User', foreign_key: 'participant_id'
end
