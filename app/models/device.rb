class Device < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true
  validates :notification_token, presence: true,
                                 uniqueness: true,
                                 length: { maximum: 255 }

  scope :active, ->{ where(active: true) }

end
