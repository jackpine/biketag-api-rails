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
                                                     greater_than: 0.003, # not sure what units this is in, but anecdoatally, it's about 250 meters
                                                     message: 'must be farther',
                                                     allow_nil: true #nil for first spot in game

  validates_presence_of :user, :game

  def self.near(point)
    order("ST_Distance(location, ST_GeomFromText('#{point.as_text}', 4326))")
  end

  def self.current
    current_spot_ids = group("game_id").maximum("id").values
    where(id: current_spot_ids)
  end

  def distance_from_last_spot
    return nil if self.game.nil? || self.game.spots.empty?

    self[:location].distance(self.game.spots.last[:location])
  end

  def image_url
    image.url(:large)
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

  def submit_new_spot
    self.game ||= Game.new

    return false unless valid?

    Spot.transaction do
      if game.new_record?
        ScoreTransaction.debit_for_new_game(self)
      end
      save!
    end
    true
  end

end
