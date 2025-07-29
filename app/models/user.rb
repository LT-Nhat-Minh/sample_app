class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
                   length: { maximum: Settings.user.name_max_length }
  validates :email,
            presence: true,
            length: { maximum: Settings.user.email_max_length },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true

  validate :birthday_valid

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end

  def birthday_valid
    return if birthday.blank?

    if birthday > Date.today
      errors.add(:birthday, :in_future)
    elsif birthday < Settings.user.birthday_min_age.years.ago
      errors.add(:birthday, :too_old)
    end
  end
end
