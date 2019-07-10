class BlockUser < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  validates_uniqueness_of :user_id, scope: :receiver_id

end
