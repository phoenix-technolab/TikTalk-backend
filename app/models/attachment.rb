# == Schema Information
#
# Table name: attachments
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Attachment < ApplicationRecord
  belongs_to :user
  validates :image, presence: true
  mount_uploader :image, AttachmentUploader
end
