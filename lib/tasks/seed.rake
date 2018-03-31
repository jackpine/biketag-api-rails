namespace :db do
  task seed: :environment do
    require File.join(Rails.root, 'db', 'seeds')
    Seeds.seed!
  end
end
