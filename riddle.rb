require 'ostruct'

class Riddle
  def initialize(people)
    @people = people
  end

  def call
    recursive_solution(
      people_on_start: @people,
      people_on_other_side: [],
      time: 0
    )
  end

  def recursive_solution(people_on_start:, people_on_other_side:, time: 0, movements: [], lantern_on: :start)
    return OpenStruct.new(
      movements: movements,
      time: time,
      success: people_on_other_side.count == 4 && time <= 17
    ) if time > 17 || people_on_other_side.count == 4

    people_to_move = lantern_on == :start ? people_on_start : people_on_other_side

    possible_moves = moves_to_try(people_to_move, lantern_on)

    results = possible_moves.lazy.map do |people_moving|
      if lantern_on == :start
        updated_people_on_start = people_on_start - people_moving
        updated_people_on_other_side = people_on_other_side + people_moving
      else
        updated_people_on_start = people_on_start + people_moving
        updated_people_on_other_side = people_on_other_side - people_moving
      end

      recursive_solution(
        people_on_start: updated_people_on_start,
        people_on_other_side: updated_people_on_other_side,
        time: time + people_moving.max,
        movements: movements + [people_moving],
        lantern_on: lantern_on == :start ? :other : :start
      )
    end

    results.find(&:success) || results.first
  end

  def moves_to_try(people_to_move, lantern_on)
    return [[people_to_move.min]] if lantern_on == :other

    (
      people_to_move.permutation(2).to_a.shuffle +
      people_to_move.map { |person| [person] }
    )
  end
end
