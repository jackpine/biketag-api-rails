namespace :device do
  desc "deactivate devices Apple has reported as stale"
  task purge: :environment do
    Rails.logger.info("Deactivating stale devices.")
    DeviceNotifier.new.deactivate_stale_devices!
  end
end
