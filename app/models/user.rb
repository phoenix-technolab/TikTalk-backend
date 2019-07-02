class User < ApplicationRecord
  acts_as_mappable default_units: :kms
  has_many :attachments, dependent: :destroy

  enum gender: [:male, :female]

  validates :gender, :email, :name, :birth_date, :country, :city, :phone_number, :code_country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true



  scope :by_gender, lambda{ |current_user|
    prefer_gender_male = current_user.prefer_gender_male
    prefer_gender_female = current_user.prefer_gender_female

    if prefer_gender_male && prefer_gender_female
      where("gender IN (0, 1) AND prefer_gender_#{gender} = ?", true)
    elsif current_user.male? && prefer_gender_male
      where(gender: 0, prefer_gender_male: true)
    elsif current_user.female? && prefer_gender_female
      where(gender: 1, prefer_gender_female: true)
    elsif current_user.male? && prefer_gender_female
      where(gender:1, prefer_gender_male: true)
    elsif current_user.female? && prefer_gender_male
      where(gender:0, prefer_gender_female: true)   
    end
  }

  scope :by_age, lambda{ |current_user|
    min_age = current_user.prefer_min_age
    max_age = current_user.prefer_max_age
    where("date_part('year', age(birth_date)) >= ? AND date_part('year', age(birth_date)) <= ?", min_age, max_age)
  }

  scope :by_distance, lambda{ |current_user|
    prefer_location_distance_in_miles = current_user.prefer_location_distance * 0.621371
    lat = current_user.lat
    lng = current_user.lng
    bounds = Geokit::Bounds.from_point_and_radius([lat, lng], prefer_location_distance_in_miles)
    User.in_bounds(bounds)
  }

  scope :by_show_in_app, -> { where(is_show_in_app: true) }
  

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
