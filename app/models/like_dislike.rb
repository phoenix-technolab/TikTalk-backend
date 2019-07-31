# == Schema Information
#
# Table name: like_dislikes
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  receiver_id :bigint
#  status      :integer          default("nothing")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LikeDislike < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  validates :status, presence: true
  validates_uniqueness_of :user_id, scope: :receiver_id


  enum status: %I(nothing dislike like super_like)
end
