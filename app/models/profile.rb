class Profile < ApplicationRecord
  belongs_to :user
  enum relationship: %I(no_answer single taken)
  enum sexuality: %I(no_answer bisexual gay ask_me straight), _prefix: true
  enum living: %I(no_answer by_myself student_residence with_parents with_partner with_housemate), _prefix: true
  enum children: %I(no_answer grown_up already_have no_never someday), _prefix: true
  enum smoking: %I(no_answer heavy_smoker hate_smoking dont_like_it social_smoker smoke_occasionally), _prefix: true
  enum drinking: %I(no_answer drink_socially dont_drink against_drinking drink_a_lot), _prefix: true
end
