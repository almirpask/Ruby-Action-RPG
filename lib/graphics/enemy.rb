require 'ruby2d'

class Graphics
  class Enemy < Sprite
    attr_reader :collision
    attr_accessor :hit_box, :direction, :shadow, :player_zone_detection
    def initialize
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
        opacity: 0.5,
        z: 20
      )

      @collision = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'teal',
        opacity: 0.5,
        z: 20
      )

      @hit_box = Rectangle.new(
        x: x + 4, y: y + 19,
        width: 10, height: 6,
        color: 'teal',
        opacity: 0.5,
        z: 20
      )
    end

    def move_collision
      @collision.x = x + 26
      @collision.y = y + 40

      set_hit_box_direction @direction.to_sym
    end
  end
end
