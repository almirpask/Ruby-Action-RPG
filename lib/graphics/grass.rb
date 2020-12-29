require 'ruby2d'

class Graphics::Grass < Sprite
  attr_accessor :collision, :destructible
  attr_writer :position, :collision_opacity

  def initialize(x:, y:, collision_opacity: 0)
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
    @collision_opacity, = collision_opacity
    @collision = Rectangle.new(
      x: x + 8, y: 8,
      width: 16,
      height: 16,
      color: 'teal',
      opacity: @collision_opacity,
      z: 20
    )
    @position = { **dimensions, x: x, y: y, clip_width: dimensions[:width] }
    @destructible = true
  end

  def destroy
    remove
    collision.remove
    grass_effect = Sprite.new(
      'assets/images/GrassEffect.png',
      z: 5,
      **@position,
      time: 100,
      opacity: opacity
    )
    grass_effect.play do
      grass_effect.opacity = 0
    end
  end
end
