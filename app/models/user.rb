class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: {maximum: Settings.email.length.maximum},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                       length: {minimum: Settings.password.length.minimum}
  validates :name, presence: true,
                   length: {maximum: Settings.name.length.maximum}
  before_save :downcase_email
  has_secure_password

  def downcase_email
    email.downcase!
  end
end
