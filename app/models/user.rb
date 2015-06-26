class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable, :rememberable, 
  devise :database_authenticatable, :trackable, :validatable
  has_one :api_key

  validates :email, uniqueness: { allow_blank: true }
  validates :name, uniqueness: { allow_blank: true},
                   length: { in: 4..16, allow_blank: true }

  # We allow users to identify using their device id
  def email_required?
    false
  end

  # Password need only be set when user gives their email
  # Otherwise they are using a (non-recoverable!) api key
  def password_required?
    email.present?
  end

  def name
    self[:name] || "User ##{id}"
  end
end
