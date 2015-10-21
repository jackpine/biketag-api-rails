require 'rails_helper'

describe NameGenerator do
  describe '#generate' do
    it 'combines an adjective with an animal name' do
      expect(NameGenerator.new.generate(2).length).to be >= 2
    end

    it 'gives the same name given the same parameter' do
      name = NameGenerator.new.generate(2)
      expect(NameGenerator.new.generate(2)).to eq(name)
    end

    it '(probably) gives a different name given the same parameter' do
      name = NameGenerator.new.generate(2)
      expect(NameGenerator.new.generate(30000)).not_to eq(name)
    end
  end
end

