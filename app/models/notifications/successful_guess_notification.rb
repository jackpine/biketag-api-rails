class Notifications::SuccessfulGuessNotification < Notifications::DeviceNotification
  attr_reader :guesser_name, :recipient_token

  def initialize(guess, recipient_token)
    @guesser_name = guess.user_name
    @recipient_token = recipient_token
  end

  private

  def notification_payload
    Houston::Notification.new(device: recipient_token).tap do |notification|
      notification.alert = notification_alert
    end
  end

  def notification_alert
    "#{guesser_name} captured your spot!"
  end
end
