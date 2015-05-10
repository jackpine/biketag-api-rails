class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable, :recoverable, :rememberable, 
  devise :trackable, :validatable

  validates :device_id, uniqueness: { scope: :email, message: "has already been registered" }
  validates :email, uniqueness: { allow_blank: true }

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def session
    raise StandardError.new("Can't return session for uninitialized user") unless (id && authentication_token)

    {
      user_id: id,
      authentication_token: authentication_token
    }
  end

  # We allow users to identify using their device id
  def email_required?
    false
  end

  # Password need only be set when user gives their email
  # Otherwise they are using a (non-recoverable!) api key
  def password_required?
    email.present?
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
