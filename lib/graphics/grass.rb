require 'ruby2d'

class Graphics::Grass < Sprite
  attr_accessor :collision, :destructible
  def initialize(x:, y:)
    dimensions = {
      width: 32,
      height: 32
    }
    super(
      'assets/images/Grass.png',
      x: x,
      y: y,
      z: 5,
      opacity: 1,
      **dimensions
    )

    @collision = Rectangle.new(
      x: x + 8, y: 8,
      width: 16,
      height: 16,
      color: 'teal',
      opacity: 0.5,
      z: 20
    )

    @destructible = true
  end

  def destroy
    self.remove
  end
end
