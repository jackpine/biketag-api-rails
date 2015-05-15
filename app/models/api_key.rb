class ApiKey < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :client_id, :secret
  validates_associated :user

  after_initialize :ensure_authentication_tokens

  def ensure_authentication_tokens
    self.client_id = self.class.friendly_token_for(:client_id)
    self.secret = self.class.friendly_token_for(:secret)
  end

  def self.friendly_token_for(attr)
    loop do
      token = Devise.friendly_token
      break token unless self.find_by(attr => token)
    end
  end
end
