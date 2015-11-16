require_relative '../riddle'

class State
  attr_reader :people_on_start_side, :people_on_other_side
  attr_reader :side_lantern_is_on

  def initialize(people_on_start_side:, people_on_other_side:, time: 0)
    @people_on_start_side = people_on_start_side
    @people_on_other_side = people_on_other_side
    @time = time
    @side_lantern_is_on = :start
  end

  def update(movement)
    if @side_lantern_is_on == :start
      @people_on_start_side -= movement
      @people_on_other_side += movement
      @side_lantern_is_on = :other
    else
      @people_on_start_side += movement
      @people_on_other_side -= movement
      @side_lantern_is_on = :start
    end

    self
  end
end

require 'ostruct'

describe Riddle do
  let(:people) {
    [1, 2, 5, 10]
  }

  subject(:results) { Riddle.new(people).call }

  it 'takes all of the people across the bridge in less than 17 minutes' do
    expect(results.time).to be <= 17

    p results
  end

  it 'returns movements' do
    expect(results.movements).to be_an Array
  end

  describe '#movements' do
    subject(:movements) { results.movements }

    it 'describes a series of moves to get everyone across' do
      state = State.new(people_on_start_side: people, people_on_other_side: [])

      expect(state.people_on_start_side.count).to eq 4
      expect(state.people_on_other_side.count).to eq 0
      expect(state.side_lantern_is_on).to eq :start

      movements.reduce(state) do |state, movement|
        state.update(movement)
      end

      expect(state.people_on_start_side.count).to eq 0
      expect(state.people_on_other_side.count).to eq 4
    end
  end
end
