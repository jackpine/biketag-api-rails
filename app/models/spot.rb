class Spot < ActiveRecord::Base

  has_many :guesses
  belongs_to :user
  belongs_to :game

  has_attached_file :image, styles: { large: '1600x1600>',
                                      medium: '800x800>',
                                      small: '400x400>',
                                      thumb: '100x100>' }

  validates_attachment :image, presence: true,
                               content_type: { content_type: ['image/jpg', 'image/jpeg'] }

  validates_numericality_of :distance_from_last_spot, on: :create,
                                                     greater_than: 0.003,
                                                     message: 'must be farther',
                                                     allow_nil: true #nil for first spot in game

  validates_presence_of :user, :game

  def distance_from_last_spot
    return nil if self.game.spots.empty?

    self[:location].distance(self.game.spots.last[:location])
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
