class NameGenerator
  def initialize(seed = nil)
    if seed.nil?
      # specify seed for testing, otherwise generate integer seed
      # http://stackoverflow.com/questions/535721/ruby-max-integer
      max_integer = (2**(0.size * 8 - 2) - 1)
      seed = rand(max_integer)
    end

    @random_number_generator = Random.new(seed)
    @@adjectives ||= File.read('db/seeds/words/adjectives.txt').split("\n")
    @@animals ||= File.read('db/seeds/words/animals.txt').split("\n")
  end

  def generate
    adjective = get(@@adjectives)
    animal = get(@@animals)
    name = "#{adjective} #{animal}".titlecase
    name
  end

  def get(list)
    list[@random_number_generator.rand(list.length)]
  end
end
