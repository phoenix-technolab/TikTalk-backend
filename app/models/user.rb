class User < ApplicationRecord
  # before_save :create_new_auth_token
  has_many :attachments, dependent: :destroy

  enum gender: [:male, :female]

  validate :phone_number_verified
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: proc { email.present? }
  validates :phone_number, presence: true

  def create_new_auth_token
    new_token = generate_token
    self.tokens = tokens.push(new_token)
    new_token
  end

  def phone_number_verified
    verified_status = MyRedis.client.get(self.phone_number)
    unless verified_status
      self.errors.add(:phone_number, "Your phone number not verified")
    end
  end
  
  private

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      return token if User.where("? = ANY (tokens)", token).blank?
    end
  end
end
