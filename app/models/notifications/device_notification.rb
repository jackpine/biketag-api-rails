class Notifications::DeviceNotification
  def send!
    DeviceNotifier.new.client.push(notification_payload)
  end

  def notification_payload
    raise NotImplementedError.new("Abstract method")
  end
end

