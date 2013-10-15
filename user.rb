class User
  attr_accessor :id, :name, :location

  def ==(other_user)
    @id == other_user.id && @name == other_user.name && @location == other_user.location
  end
end