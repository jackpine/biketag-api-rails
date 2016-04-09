class SpotNotifier

  class SuccessfulGuessNotification
    attr_reader :guesser_name, :recipient_token

    def initialize(guess, recipient_token)
      @guesser_name = guess.user_name
      @recipient_token = recipient_token
    end

    def send!
      Houston::Client.development.push(notification_payload)
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

  def self.send_successful_guess_notifications(guess)
    guess.spot.user.device_notification_tokens.each do |device_notification_token|
      SuccessfulGuessNotification.new(guess, device_notification_token).send!
    end
  end

end
