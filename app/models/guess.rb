class Guess < ActiveRecord::Base

  belongs_to :user
  belongs_to :spot
  has_one :game, through: :spot

  validates :location, presence: true
  validates :spot, associated: true, presence: true

  has_attached_file :image, styles: { large: '1600x1600>',
                                      medium: '800x800>',
                                      small: '400x400>',
                                      thumb: '100x100>' }

  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg'] }
                               # presence: true, # guess image is currently optional

  def image_url
    image.url(:medium)
  end

  def self.generate_image_filename
    SecureRandom.uuid + '.jpg'
  end

  def correct
    self[:correct] ||= close_enough?
  end

  delegate :id, to: :game, prefix: true

  before_save do
    correct

    # if before_save returns false, the record won't save, so we force returning
    # true here so that incorrect guesses still save.
    true
  end

  def complete_guess
    if save
      ScoreTransaction.create_for_guess(self, self.user)
    else
      false
    end
  end

  def close_enough?
    # This distance was generated experimentally. It's about 250 feet (75 meters).
    # I have no idea what unit this measurement could possibly be in.
    # Some gentle research says it's in "whatever unit your projection is in"
    distance < 0.001
  end

  def distance
    raise RuntimeError.new("attempting to compare to non-existant spot") unless spot.present?
    raise RuntimeError.new("attempting to compare to empty location") unless spot.location.present? && self.location.present?

    self[:location].distance(spot[:location])
  end

  def location=(val)
    val = val.deep_stringify_keys if val.class == Hash
    self[:location] = RGeo::GeoJSON.decode(val).to_s
  end

  def location
    RGeo::GeoJSON.encode(self[:location])
  end

  def promote_to_spot!
    Spot.transaction do
      Spot.create!(location: self.location, image: self.image, user: self.user, game: Game.create!)
    end
  end
end
