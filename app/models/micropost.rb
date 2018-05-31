class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true,
    length: {maximum: Settings.micropost.length.maximum}
  validates :user_id, presence: true
  validate  :picture_size
  scope :feed, ->user_id do
    following_ids = Relationship.followed_ids_by_follower_id user_id
    all_user_ids = following_ids + [user_id]
    where user_id: all_user_ids
  end
  scope :order_desc, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    if picture.size > Settings.picture.size.maximum.megabytes
      errors.add :picture, t("microposts.less_than")
    end
  end
end
