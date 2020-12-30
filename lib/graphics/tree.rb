require 'ruby2d'

class Graphics
  class Tree < Sprite
    attr_accessor :collision, :ysort, :destructible
    attr_reader :collision_opacity
    def initialize(x:, y:, collision_opacity: 0)
      super(
        'assets/images/Tree.png',
        z: 5,
        x: x,
        y: y,
        width: 32,
        height: 48
      )

      @collision_opacity, = collision_opacity
      @destructible = false

      @ysort = Rectangle.new(
        x: x, y: y,
        width: 32, height: 39,
        color: 'red',
        opacity: @collision_opacity,
        z: 20
      )

      @collision = Rectangle.new(
        x: x, y: y + 39,
        width: 32, height: 10,
        color: 'teal',
        opacity: @collision_opacity,
        z: 20
      )

      @shadow = Sprite.new(
        'assets/images/LargeShadow.png',
        width: 32,
        height: 14,
        x: x + 0.5,
        y: (y + 40),
        z: z,
        opacity: 1
      )
    end
  end
end
