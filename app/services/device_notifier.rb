class DeviceNotifier

  PRODUCTION_ENV = "production"
  DEVELOPMENT_ENV = "development"

  def self.set_production_notification_environment!
    @@notification_environment = PRODUCTION_ENV
  end

  def self.production_notification_environment?
    @@notification_environment == PRODUCTION_ENV
  end

  def self.set_development_notification_environment!
    @@notification_environment = DEVELOPMENT_ENV
  end

  def self.development_notification_environment?
    @@notification_environment == DEVELOPMENT_ENV
  end

  def client
    self.class.production_notification_environment? ? Houston::Client.production : Houston::Client.development
  end

  # It's important to regularly remove devices that Apple reporst as stale.  If
  # you continue to try to notify stale devices, Apple may revoke your access
  # to APNS
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
end
