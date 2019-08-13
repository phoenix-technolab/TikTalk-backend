# == Schema Information
#
# Table name: profiles
#
#  id                       :bigint           not null, primary key
#  prefer_gender_male       :boolean          default(FALSE)
#  prefer_gender_female     :boolean          default(TRUE)
#  prefer_min_age           :integer          default(18)
#  prefer_max_age           :integer          default(25)
#  prefer_location_distance :integer          default(10)
#  is_show_in_app           :boolean          default(TRUE)
#  is_show_in_places        :boolean          default(TRUE)
#  work                     :string
#  education                :string
#  about_you                :string
#  relationship             :integer          default("no_answer")
#  sexuality                :integer          default("no_answer")
#  height                   :integer
#  living                   :integer          default("no_answer")
#  children                 :integer          default("no_answer")
#  smoking                  :integer          default("no_answer")
#  drinking                 :integer          default("no_answer")
#  languages                :string           default([]), is an Array
#  user_id                  :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  instagram_photos_url     :string           default([]), is an Array
#  twilio_user_id           :string           default("")
#  notifications            :json
#  zodiac                   :integer          default("no_answer"), not null
#

require 'rails_helper'

RSpec.describe Profile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
