class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  USER_PERMIT = %i(name email password birthday).freeze

  validates :name, presence: true,
                   length: {maximum: Settings.user.name_max_length}
  validates :email,
            presence: true,
            length: {maximum: Settings.user.email_max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true

  validate :birthday_valid

  before_save :downcase_email

  attr_accessor :remember_token, :session_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def create_session_token
    self.session_token = User.new_token
    update_column :remember_digest, User.digest(session_token)
    remember_token
  end

  def authenticated_with_session? session_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? session_token
  end

  def forget
    update_column :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end

  def birthday_valid
    return if birthday.blank?

    if birthday > Time.zone.today
      errors.add(:birthday, :in_future)
    elsif birthday < Settings.user.birthday_min_age.years.ago
      errors.add(:birthday, :too_old)
    end
  end
end
