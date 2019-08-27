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

require 'rails_helper'

RSpec.describe UserStream, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
