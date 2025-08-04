class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image,
            content_type: {
              in: %w[image/jpeg image/gif image/png],
              message: I18n.t("microposts.validations.image.content_type")
            },
            size: {
              less_than: 5.megabytes,
              message: I18n.t("microposts.validations.image.size")
            }

  scope :recent_posts, -> { order(created_at: :desc) }
end
