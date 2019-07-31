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

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
