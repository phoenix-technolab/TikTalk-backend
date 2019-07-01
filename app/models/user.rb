class User < ApplicationRecord
  acts_as_mappable default_units: :kms
  has_many :attachments, dependent: :destroy

  enum gender: [:male, :female]

  # validate :phone_number_verified
  # validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: proc { email.present? }
  # validates :phone_number, presence: true


  scope :by_gender, lambda{ |gender, prefer_gender_male, prefer_gender_female|
    if prefer_gender_male && prefer_gender_female
      where("gender IN (0, 1) AND prefer_gender_#{gender} = ?", true)
    elsif gender.eql?("male") && prefer_gender_male
      where(gender: 0, prefer_gender_male: true)
    elsif gender.eql?("female") && prefer_gender_female
      where(gender: 1, prefer_gender_female: true)
    elsif gender.eql?("male") && prefer_gender_female
      where(gender:1, prefer_gender_male: true)
    elsif gender.eql?("female") && prefer_gender_male
      where(gender:0, prefer_gender_female: true)   
    end
  }

  scope :by_age, -> (min, max) {
    where("date_part('year', age(birth_date)) >= ? AND date_part('year', age(birth_date)) <= ?", min, max)
  }

  scope :by_distance, lambda{ |user_location, prefer_location_distance_in_kms|
    prefer_location_distance_in_miles = prefer_location_distance_in_kms * 0.621371
    bounds = Geokit::Bounds.from_point_and_radius(user_location, prefer_location_distance_in_miles)
    pp bounds
    User.in_bounds(bounds)
  }

  scope :by_show_in_app, -> (is_show_in_app) { where(is_show_in_app: true) }
  

  def create_new_auth_token
    new_token = generate_token
    self.tokens = tokens.push(new_token)
    new_token
  end

  # def phone_number_verified
  #   verified_status = MyRedis.client.get(self.phone_number)
  #   unless verified_status
  #     self.errors.add(:phone_number, "Your phone number not verified")
  #   end
  # end
  
  private

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      return token if User.where("? = ANY (tokens)", token).blank?
    end
  end
end
