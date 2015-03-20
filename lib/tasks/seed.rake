namespace :db do
  task seed: :environment do
    require Rails.root + 'db/seeds.rb'
    Seeds.seed!
  end
end
