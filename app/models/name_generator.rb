class NameGenerator
  def initialize
    @adjectives = File.read('db/seeds/words/adjectives.txt').split("\n")
    @animals = File.read('db/seeds/words/animals.txt').split("\n")
  end

  def generate(seed)
    adjective = get(@adjectives, seed) 
    animal = get(@animals, seed)
    name = "#{adjective} #{animal}".titlecase
    name
  end

  def get(list, seed)
    random_number_generator = Random.new(seed)
    list[random_number_generator.rand(list.length)]
  end
end
