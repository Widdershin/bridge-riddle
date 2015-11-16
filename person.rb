class Person
  NoLanternError = StandardError.new

  attr_reader :travel_time
  attr_writer :has_lantern

  def initialize(travel_time:, lantern: false)
    @travel_time = travel_time
    @has_lantern = lantern
  end

  def has_lantern?
    @has_lantern
  end

  def give_lantern(person)
    raise NoLanternError if !has_lantern?

    person.has_lantern = true

    @has_lantern = false
  end
end
