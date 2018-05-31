class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  attr_accessor :remember_token, :activation_token
  validates :email, presence: true,
                    length: {maximum: Settings.email.length.maximum},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :name, presence: true,
                   length: {maximum: Settings.name.length.maximum}
  validates :password, presence: true,
                       length: {minimum: Settings.password.length.minimum},
                       allow_nil: true
  before_create :create_activation_digest
  before_save :downcase_email
  scope :activated, ->{where activated: true}
  has_secure_password

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  def downcase_email
    email.downcase!
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end
end
