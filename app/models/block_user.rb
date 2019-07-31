# == Schema Information
#
# Table name: block_users
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  receiver_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BlockUser < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  validates_uniqueness_of :user_id, scope: :receiver_id

end
