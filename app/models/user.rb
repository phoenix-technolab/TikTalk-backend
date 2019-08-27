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
#

class User < ApplicationRecord
  acts_as_mappable default_units: :kms

  with_options dependent: :destroy do |assoc|
    assoc.has_many :attachments
    assoc.has_one  :profile
    assoc.has_many :reports
    assoc.has_many :complaints, class_name: 'Report', foreign_key: 'receiver_id'
    assoc.has_many :like_dislikes
    assoc.has_many :receives, class_name: 'LikeDislike', foreign_key: 'receiver_id'
    assoc.has_many :block_users
    assoc.has_many :blocked_by, class_name: 'BlockUser', foreign_key: 'receiver_id'
    assoc.has_one  :stream
    assoc.has_many :user_streams, foreign_key: :participant_id
  end

  has_many :participated_streams, through: :user_streams, source: :stream
  
  after_create :create_profile

  enum gender: %I(male female)

  validates :gender, :email, :name, :birth_date, :country, :city, :phone_number, :code_country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }

  scope :by_gender, lambda{ |current_user|
    prefer_gender_male = current_user.profile.prefer_gender_male
    prefer_gender_female = current_user.profile.prefer_gender_female
    gender = current_user.gender

    join_with_profile
    
    if prefer_gender_male && prefer_gender_female
      where("users.gender IN (0, 1) AND profiles.prefer_gender_#{gender} = ?", true)
    elsif current_user.male? && prefer_gender_male
      where(gender: 0, profiles: { prefer_gender_male: true })
    elsif current_user.female? && prefer_gender_female
      where(gender: 1, profiles: { prefer_gender_female: true })
    elsif current_user.male? && prefer_gender_female
      where(gender:1, profiles: { prefer_gender_male: true })
    elsif current_user.female? && prefer_gender_male
      where(gender:0, profiles: { prefer_gender_female: true })   
    end
  }

  scope :join_with_profile, -> { self.joins(:profile) }

  scope :by_age, lambda{ |current_user|
    min_age = current_user.profile.prefer_min_age
    max_age = current_user.profile.prefer_max_age
    where("date_part('year', age(birth_date)) >= ? AND date_part('year', age(birth_date)) <= ?", min_age, max_age)
  }

  scope :by_distance_to_user, lambda{ |current_user|
    prefer_location_distance_in_miles = current_user.profile.prefer_location_distance * 0.621371
    lat = current_user.lat
    lng = current_user.lng
    bounds = Geokit::Bounds.from_point_and_radius([lat, lng], prefer_location_distance_in_miles)
    User.in_bounds(bounds)
  }

  scope :by_show_in_app, -> {  join_with_profile.where(profiles: { is_show_in_app: true }) }

  scope :no_display_reported_users, lambda{ |current_user| 
    array_receiver_ids = Report.where(user_id: current_user.id).pluck(:receiver_id)
    where.not(id: array_receiver_ids) 
  }

  scope :no_display_liked_or_disliked, lambda{ |current_user|
    array_receiver_ids = LikeDislike.where(user_id: current_user.id).pluck(:receiver_id)
    where.not(id:[array_receiver_ids])
  }
  def create_new_auth_token
    new_token = generate_token
    self.tokens = tokens.push(new_token)
    new_token
  end

  def allow_reset!(status)
    self.update(can_reset: status)
  end

  private

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      return token if User.where("? = ANY (tokens)", token).blank?
    end
  end
end
