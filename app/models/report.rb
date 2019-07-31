# == Schema Information
#
# Table name: reports
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  report_type :integer
#  receiver_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Report < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  validates :report_type, presence: true

  enum report_type: %I(inappropriate_profile inappropriate_messages stolen_photo
                       scammer bad_offline_behavior other)
end
