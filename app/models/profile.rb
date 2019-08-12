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
#

class Profile < ApplicationRecord
  belongs_to :user
  enum relationship: %I(no_answer single taken)
  enum sexuality: %I(no_answer bisexual gay ask_me straight), _prefix: true
  enum living: %I(no_answer by_myself student_residence with_parents with_partner with_housemate), _prefix: true
  enum children: %I(no_answer grown_up already_have no_never someday), _prefix: true
  enum smoking: %I(no_answer heavy_smoker hate_smoking dont_like_it social_smoker smoke_occasionally), _prefix: true
  enum drinking: %I(no_answer drink_socially dont_drink against_drinking drink_a_lot), _prefix: true
  enum zodiac: %I(no_answer aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces), _prefix: true
end
