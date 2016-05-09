class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable, :rememberable,
  devise :database_authenticatable, :trackable, :validatable
  has_one :api_key
  has_many :spots
  has_many :guesses
  has_many :score_transactions
  has_many :games, through: :spots
  has_many :devices

  validates :email, uniqueness: { allow_blank: true }
  validates :name, length: { in: 4..20, allow_blank: true }

  include RoleModel
  roles :admin

  def name
    if self[:name].blank?
      "User ##{self.id}"
    else
      self[:name]
    end
  end

  def email_required?
    false
  end

  # Password need only be set when user gives their email
  # Otherwise they are using a (non-recoverable!) api key
  def password_required?
    email.present?
  end

  def compute_score
    update_attribute(:score, score_transactions.sum(:amount))
  end

  def self.create_for_game!(attributes = {})
    user = nil
    ActiveRecord::Base.transaction do
      attributes[:name] ||= NameGenerator.new.generate
      user = create!(attributes)
      user.create_api_key!
      ScoreTransaction.credit_for_new_user(user)
    end
    user
  end

  def active_device_notification_tokens
    devices.active.select('active, notification_token').map(&:notification_token)
  end

end
