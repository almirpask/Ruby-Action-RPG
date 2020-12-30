require 'ruby2d'

class Graphics
  class Enemy < Sprite
    attr_accessor :hit_box, :direction, :shadow, :player_zone_detection, :collision, :hurt_box
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
        z: 40,
        time: 110,
        loop: true
      )

      z = 40

      @collision_opacity = collision_opacity

      @shadow = Sprite.new(
        'assets/images/SmallShadow.png',
        width: 10,
        height: 8,
        x: x + 4,
        y: y + 18,
        z: z,
        opacity: 1
      )

      set_collision

      @direction = 'right'
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

    def remove
      super
      @player_zone_detection.remove
      @collision.remove
      @hit_box.remove
      @hurt_box.remove
      @shadow.remove
      @shadow.opacity = 0
    end

    private

    def set_collision
      @player_zone_detection = Rectangle.new(
        x: x - 54, y: y - 40,
        width: 120, height: 120,
        color: 'green',
        opacity: @collision_opacity,
        z: z
      )

      @collision = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'black',
        opacity: @collision_opacity,
        z: z
      )

      @hit_box = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'teal',
        opacity: @collision_opacity,
        z: z
      )
      @hurt_box = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'teal',
        opacity: @collision_opacity,
        z: z
      )
    end

    def move_collision
      @collision.x = x + 4
      @collision.y = y + 19
      @collision.z = z

      @player_zone_detection.x = x - 54
      @player_zone_detection.y = y - 40
      @player_zone_detection.z = z

      @hit_box.x = x + 4
      @hit_box.y = y + 19
      @hit_box.z = z

      @hurt_box.x = x + 4
      @hurt_box.y = y + 19
      @hurt_box.z = z

      @shadow.x = x + 4
      @shadow.y = y + 18
      @shadow.z = z
    end
  end
end
