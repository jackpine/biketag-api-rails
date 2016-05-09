class Notifications::DeviceNotification

  def notification_payload
    raise NotImplementedError.new("Abstract method")
  end

end

