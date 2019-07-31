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

require 'rails_helper'

RSpec.describe BlockUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
