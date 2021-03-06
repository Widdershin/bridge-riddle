require_relative '../riddle'

class State
  attr_reader :people_on_start_side, :people_on_other_side
  attr_reader :time
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

    @time += movement.max

    self
  end
end

require 'ostruct'

describe Riddle do
  let(:people) { [1, 2, 5, 10] }

  subject(:results) { Riddle.new(people).call }

  it 'gets everyone across the bridge in 17 minutes or less' do
    state = State.new(people_on_start_side: people, people_on_other_side: [])

    expect(state.people_on_start_side.count).to eq 4
    expect(state.people_on_other_side.count).to eq 0
    expect(state.side_lantern_is_on).to eq :start

    results.movements.reduce(state) do |state, movement|
      state.update(movement)
    end

    expect(state.people_on_start_side.count).to eq 0
    expect(state.people_on_other_side.count).to eq 4
    expect(state.time).to eq results.time
    expect(results.time).to be <= 17
  end
end
