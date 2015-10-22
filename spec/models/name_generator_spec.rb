require 'rails_helper'

describe NameGenerator do
  describe '#generate' do
    it 'combines an adjective with an animal name' do
      expect(NameGenerator.new(1).generate).to eq 'Colossal Meerkat'
    end

    it 'gives the same name given the same seed' do
      name = NameGenerator.new(1).generate
      expect(NameGenerator.new(1).generate).to eq(name)
    end

    it '(probably) gives a different name given the same seed' do
      name = NameGenerator.new(1).generate
      expect(NameGenerator.new(2).generate).not_to eq(name)
    end
  end
end

