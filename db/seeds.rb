# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

class Seeds

  class_attribute :lucile_spot

  def self.seed!
    self.lucile_spot = Spot.new location: { type: "Point",
                                  coordinates: [-118.3240, 34.0937] },
    image_file_name: 'foo'

    lucile_image_path = Rails.root + 'db/seeds/images/952_lucile.jpg'
    attach = Paperclip::Attachment.new(:image, lucile_spot, lucile_spot.class.attachment_definitions[:image])
    file = File.open(lucile_image_path)
    attach.assign file
    attach.save
    file.close

    lucile_spot.save!
  end
end
