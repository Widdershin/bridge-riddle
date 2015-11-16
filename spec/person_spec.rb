require_relative '../person'

describe Person do
  let(:fred) { Person.new(travel_time: 0, lantern: true) }
  let(:wilma) { Person.new(travel_time: 10) }

  it 'starts out without a lantern' do
    expect(wilma.has_lantern?).to be false
  end

  describe '#give_lantern' do
    it 'moves the lantern between people' do
      expect(fred.has_lantern?).to be true
      expect(wilma.has_lantern?).to be false

      fred.give_lantern(wilma)

      expect(fred.has_lantern?).to be false
      expect(wilma.has_lantern?).to be true
    end
  end
end
