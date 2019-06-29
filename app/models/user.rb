class User < ApplicationRecord
  has_many :attachments, dependent: :destroy

  enum gender: [:male, :female]

  validates :gender, :email, :name, :birth_date, :country, :city, :phone_number, :code_country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def create_new_auth_token
    new_token = generate_token
    self.tokens = tokens.push(new_token)
    new_token
  end

  def email_valid?
    self.email.present? && User.where(email: self.email).blank?
  end
  
  private

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      return token if User.where("? = ANY (tokens)", token).blank?
    end
  end
end
