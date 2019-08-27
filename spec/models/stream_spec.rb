# == Schema Information
#
# Table name: streams
#
#  id                 :bigint           not null, primary key
#  lon                :string
#  lat                :string
#  user_id            :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  participants_count :integer          default(0)
#

require 'rails_helper'

RSpec.describe Stream, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
