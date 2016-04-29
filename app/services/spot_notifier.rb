class SpotNotifier < DeviceNotifier

  def self.send_successful_guess_notifications(guess)
    guess.spot.user.active_device_notification_tokens.each do |device_notification_token|
      Notifications::SuccessfulGuessNotification.new(guess, device_notification_token).send!
    end
  end

end
