# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

class Seeds

  class_attribute :lucile_spot, :user, :game

  def self.seed!
    self.user = User.create_for_game!(name: "First User", roles: :admin)
    self.user.devices.create!(notification_token: "footch")

    self.game = Game.create!
    self.lucile_spot = Spot.new(location: { type: "Point",
                                            coordinates: [-118.281617, 34.086588] },
                                game: self.game,
                                user: self.user)
    lucile_image_path = Rails.root + 'db/seeds/images/952_lucile.jpg'
    File.open(lucile_image_path) do |lucile_image|
      lucile_spot.image = lucile_image
      lucile_spot.save!
    end
  end
end
