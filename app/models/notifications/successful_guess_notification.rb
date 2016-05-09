class Notifications::SuccessfulGuessNotification < Notifications::DeviceNotification
  attr_reader :guesser_name

  def initialize(guess)
    @guesser_name = guess.user_name
  end

  def push_notification
    Houston::Notification.new( alert: "#{guesser_name} captured your spot!" )
  end

end
