class Attachment < ApplicationRecord
  belongs_to :user
  validates :image, presence: true
  mount_uploader :image, AttachmentUploader
end
