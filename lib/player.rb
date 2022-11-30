class Player
attr_accessor :color, :name

  def initialize(color, name = "#{color.to_s.capitalize()}")
    @color = color
    @name = name
  end

end
