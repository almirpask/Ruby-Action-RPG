require 'ruby2d'

class Graphics
  class Enemy < Sprite
    attr_accessor :hit_box, :direction, :shadow, :player_zone_detection, :collision
    attr_reader :collision_opacity
    def initialize(collision_opacity: 0)
      dimensions = {
        width: 16,
        height: 24
      }
      super(
        'assets/images/Bat.png',
        clip_width: dimensions[:width],
        **dimensions,
        x: 100,
        y: 100,
        z: 20,
        time: 110,
        loop: true
      )

      @collision_opacity, = collision_opacity
      @shadow = Sprite.new(
        'assets/images/SmallShadow.png',
        width: 10,
        height: 8,
        x: x + 4,
        y: y + 18
      )
      @direction = 'right'
      set_colision
    end

    def x=(number)
      super
      @x = number
      move_collision
    end

    def y=(number)
      super
      @y = number
      move_collision
    end

    private

    def set_colision
      @player_zone_detection = Rectangle.new(
        x: x + -22, y: y + -8,
        width: 60, height: 60,
        color: 'green',
        opacity: @collision_opacity,
        z: 20
      )

      @collision = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'teal',
        opacity: @collision_opacity,
        z: 20
      )

      @hit_box = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'teal',
        opacity: @collision_opacity,
        z: 20
      )
    end

    def move_collision
      @collision.x = x + 4
      @collision.y = y + 19

      @player_zone_detection.x = x - 22
      @player_zone_detection.y = y - 8

      @hit_box.x = x + 4
      @hit_box.y = y + 19
    end
  end
end
