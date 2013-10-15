class Project
  attr_accessor :id, :name, :created, :deadline, :location, :goal, :pledged, :backers

  def initialize (id, name, location)
    @id = id
    @name = name
    @location = location
    @backers = []
  end
end