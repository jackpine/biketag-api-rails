class Spot < ActiveRecord::Base

  has_many :guesses
  belongs_to :user

  has_attached_file :image, styles: { large: '1600x1600>',
                                      medium: '800x800>',
                                      small: '400x400>',
                                      thumb: '100x100>' }

  validates_attachment :image, presence: true,
                               content_type: { content_type: ['image/jpg', 'image/jpeg'] }

  def self.current_spot
    Spot.last
  end

  def image_url
    image.url(:medium)
  end

  def location=(val)
    val = val.deep_stringify_keys if val.class == Hash
    self[:location] = RGeo::GeoJSON.decode(val).to_s
  end

  def location
    RGeo::GeoJSON.encode(self[:location])
  end

  def self.generate_image_filename
    SecureRandom.uuid + '.jpg'
  end

end
