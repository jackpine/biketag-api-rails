if Rails.env.production?
  DeviceNotifier.set_production_notification_environment!
else
  DeviceNotifier.set_development_notification_environment!
end
