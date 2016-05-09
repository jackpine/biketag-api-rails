class DeviceNotifier

  # Used for testing notifications without talking to Apple services.
  # Intended to be compatible with Houston::Client
  class FakeAPNSClient
    attr_reader :delivered_notifications

    def initialize
      @delivered_notifications = []
    end

    def push(payload)
      @delivered_notifications << payload
      Rails.logger.debug("Pushed fake notification_payload: #{payload.inspect}")
    end
  end

  def self.notification_environment=(val)
    new_environment = ActiveSupport::StringInquirer.new(val.to_s)
    if new_environment.production? || new_environment.development? || new_environment.fake?
      @@notification_environment = new_environment
    else
      raise ArgumentError.new("unknown notification environment: #{new_environment}")
    end
  end

  def self.notification_environment
    @@notification_environment
  end

  # It's important to regularly remove devices that Apple reports as stale. If
  # you continue to try to notify stale devices, Apple may revoke your access
  # to APNS!
  def deactivate_stale_devices!
    device_tokens = client.devices
    Rails.logger.info "Found #{device_tokens.length} stale devices."
    device_tokens.each do |device_token|
      Rails.logger.debug("deactivating device with token: #{device_token}")
      devices = Device.where(notification_token: device_token)
      if devices.count == 0
        Rails.logger.info("skipping, since no device found with token: #{device_token}")
      else
        devices.each do
          Rails.logger.debug("deactivated device with token: #{device_token}")
          device.update_attribute(active: false)
        end
      end
    end
  end

  def deliver_now(notification, to: nil)
    recipient_tokens = Array(to)

    recipient_tokens.each do |recipient_token|
      Rails.logger.info("Sent push notification to: #{recipient_token}")
      push_notification = notification.push_notification
      push_notification.token = recipient_token
      client.push(push_notification)
    end
  end

  private

  def client
    @client ||=
      if self.class.notification_environment.production?
        Houston::Client.production
      elsif self.class.notification_environment.fake?
        FakeAPNSClient.new
      elsif self.class.notification_environment.development?
        Houston::Client.development
      else
        raise StandardError.new("Unkown client_notification_environment: #{self.client_notification_environment.inspect}")
      end
  end

end
