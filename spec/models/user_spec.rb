# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email            :string
#  phone_number     :string
#  code_country     :string
#  tokens           :string           default([]), is an Array
#  is_verified      :boolean          default(FALSE)
#  name             :string
#  birth_date       :datetime
#  country          :string
#  city             :string
#  gender           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_account_block :boolean          default(FALSE)
#  firebase_token   :string
#  lat              :float
#  lng              :float
#  can_reset        :boolean          default(FALSE)
#  locker_value     :string
#  locker_type      :integer
#

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
