require 'ruby2d'

class Graphics
  class Tree < Sprite
    attr_accessor :collision, :ysort, :destructible
    def initialize(x:, y:)
      super(
        'assets/images/Tree.png',
        z: 5,
        x: x,
        y: y,
        width: 32,
        height: 48
      )

      @destructible = false

      @ysort = Rectangle.new(
        x: x, y: y,
        width: 32, height: 39,
        color: 'red',
        opacity: 0.5,
        z: 20
      )

      @collision = Rectangle.new(
        x: x, y: y + 39,
        width: 32, height: 10,
        color: 'teal',
        opacity: 0.5,
        z: 20
      )
    end
  end
end
