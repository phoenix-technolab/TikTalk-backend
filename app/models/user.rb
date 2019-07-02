class User < ApplicationRecord
  acts_as_mappable default_units: :kms
  has_many :attachments, dependent: :destroy
  has_one :profile, dependent: :destroy
  after_create :create_profile

  enum gender: [:male, :female]

  validates :gender, :email, :name, :birth_date, :country, :city, :phone_number, :code_country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }

  scope :by_gender, lambda{ |current_user|
    prefer_gender_male = current_user.profile.prefer_gender_male
    prefer_gender_female = current_user.profile.prefer_gender_female
    gender = current_user.gender
    
    if prefer_gender_male && prefer_gender_female
      join_with_profile.where("users.gender IN (0, 1) AND profiles.prefer_gender_#{gender} = ?", true)
    elsif current_user.male? && prefer_gender_male
      join_with_profile.where(gender: 0, profiles: { prefer_gender_male: true })
    elsif current_user.female? && prefer_gender_female
      join_with_profile.where(gender: 1, profiles: { prefer_gender_female: true })
    elsif current_user.male? && prefer_gender_female
      join_with_profile.where(gender:1, profiles: { prefer_gender_male: true })
    elsif current_user.female? && prefer_gender_male
      join_with_profile.where(gender:0, profiles: { prefer_gender_female: true })   
    end
  }

  scope :join_with_profile, -> { self.joins(:profile) }

  scope :by_age, lambda{ |current_user|
    min_age = current_user.profile.prefer_min_age
    max_age = current_user.profile.prefer_max_age
    where("date_part('year', age(birth_date)) >= ? AND date_part('year', age(birth_date)) <= ?", min_age, max_age)
  }

  scope :by_distance, lambda{ |current_user|
    prefer_location_distance_in_miles = current_user.profile.prefer_location_distance * 0.621371
    lat = current_user.lat
    lng = current_user.lng
    bounds = Geokit::Bounds.from_point_and_radius([lat, lng], prefer_location_distance_in_miles)
    User.in_bounds(bounds)
  }

  scope :by_show_in_app, -> {  join_with_profile.where(profiles: { is_show_in_app: true }) }

  def create_new_auth_token
    new_token = generate_token
    self.tokens = tokens.push(new_token)
    new_token
  end
  
  private

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      return token if User.where("? = ANY (tokens)", token).blank?
    end
  end
end
