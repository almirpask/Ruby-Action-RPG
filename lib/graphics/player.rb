require 'ruby2d'

class Graphics
  class Player < Sprite
    attr_reader :collision, :collision_opacity
    attr_accessor :hit_box, :hurt_box, :direction, :shadow
    HIT_BOX_POSITIONS = {
      right: {
        x: 38, y: 24,
        width: 20, height: 20
      },
      left: {
        x: 6, y: 24,
        width: 20, height: 20
      },
      down: {
        x: 22, y: 44,
        width: 20, height: 20
      },
      up: {
        x: 22, y: 14,
        width: 20, height: 20
      }
    }.freeze

    def initialize(collision_opacity: 0)
      dimensions = {
        width: 64,
        height: 64
      }

      super(
        'assets/images/Player.png',
        clip_width: dimensions[:width],
        **dimensions,
        x: 0,
        y: 0,
        z: 20,
        animations: {
          idle_right: [
            { x: 0, y: 0, **dimensions, time: 100 }
          ],
          idle_up: [
            { x: 384, y: 0, **dimensions, time: 100 }
          ],
          idle_left: [
            { x: 768, y: 0, **dimensions, time: 100 }
          ],
          idle_down: [
            { x: 1152, y: 0, **dimensions, time: 100 }
          ],
          move_right: [
            { x: 64, y: 0, **dimensions, time: 100 },
            { x: 128, y: 0, **dimensions, time: 100 },
            { x: 192, y: 0, **dimensions, time: 100 },
            { x: 256, y: 0, **dimensions, time: 100 },
            { x: 320, y: 0, **dimensions, time: 100 },
            { x: 0, y: 0, **dimensions, time: 100 }
          ],
          move_up: [
            { x: 448, y: 0, **dimensions, time: 100 },
            { x: 512, y: 0, **dimensions, time: 100 },
            { x: 576, y: 0, **dimensions, time: 100 },
            { x: 640, y: 0, **dimensions, time: 100 },
            { x: 704, y: 0, **dimensions, time: 100 },
            { x: 384, y: 0, **dimensions, time: 100 }
          ],
          move_left: [
            { x: 832, y: 0, **dimensions, time: 100 },
            { x: 896, y: 0, **dimensions, time: 100 },
            { x: 960, y: 0, **dimensions, time: 100 },
            { x: 1024, y: 0, **dimensions, time: 100 },
            { x: 1088, y: 0, **dimensions, time: 100 },
            { x: 768, y: 0, **dimensions, time: 100 }
          ],
          move_down: [
            { x: 1216, y: 0, **dimensions, time: 100 },
            { x: 1280, y: 0, **dimensions, time: 100 },
            { x: 1344, y: 0, **dimensions, time: 100 },
            { x: 1408, y: 0, **dimensions, time: 100 },
            { x: 1472, y: 0, **dimensions, time: 100 },
            { x: 1152, y: 0, **dimensions, time: 100 }
          ],
          atack_right: [
            { x: 1536, y: 0, **dimensions, time: 80 },
            { x: 1600, y: 0, **dimensions, time: 80 },
            { x: 1664, y: 0, **dimensions, time: 80 },
            { x: 1728, y: 0, **dimensions, time: 80 }
          ],
          atack_up: [
            { x: 1792, y: 0, **dimensions, time: 80 },
            { x: 1856, y: 0, **dimensions, time: 80 },
            { x: 1920, y: 0, **dimensions, time: 80 },
            { x: 1984, y: 0, **dimensions, time: 80 }
          ],
          atack_left: [
            { x: 2048, y: 0, **dimensions, time: 80 },
            { x: 2112, y: 0, **dimensions, time: 80 },
            { x: 2176, y: 0, **dimensions, time: 80 },
            { x: 2240, y: 0, **dimensions, time: 80 }
          ],
          atack_down: [
            { x: 2304, y: 0, **dimensions, time: 80 },
            { x: 2368, y: 0, **dimensions, time: 80 },
            { x: 2432, y: 0, **dimensions, time: 80 },
            { x: 2496, y: 0, **dimensions, time: 80 }
          ],
          roll_right: [
            { x: 2560, y: 0, **dimensions, time: 100 },
            { x: 2624, y: 0, **dimensions, time: 100 },
            { x: 2688, y: 0, **dimensions, time: 100 },
            { x: 2752, y: 0, **dimensions, time: 100 },
            { x: 2816, y: 0, **dimensions, time: 100 }
          ],
          roll_up: [
            { x: 2880, y: 0, **dimensions, time: 100 },
            { x: 2944, y: 0, **dimensions, time: 100 },
            { x: 3008, y: 0, **dimensions, time: 100 },
            { x: 3072, y: 0, **dimensions, time: 100 },
            { x: 3136, y: 0, **dimensions, time: 100 }
          ],
          roll_left: [
            { x: 3200, y: 0, **dimensions, time: 100 },
            { x: 3264, y: 0, **dimensions, time: 100 },
            { x: 3328, y: 0, **dimensions, time: 100 },
            { x: 3392, y: 0, **dimensions, time: 100 },
            { x: 3456, y: 0, **dimensions, time: 100 }
          ],
          roll_down: [
            { x: 3520, y: 0, **dimensions, time: 100 },
            { x: 3584, y: 0, **dimensions, time: 100 },
            { x: 3648, y: 0, **dimensions, time: 100 },
            { x: 3712, y: 0, **dimensions, time: 100 },
            { x: 3776, y: 0, **dimensions, time: 100 }
          ]
        }
      )
      @collision_opacity, = collision_opacity
      @direction = 'right'

      set_collision
      set_effect
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
      @hurt_box.remove
      @shadow.remove
      @hit_box.remove
      @collision.remove
    end

    def play_sound(sound)
      case sound
      when :evade
        @evade_sound.play
      when :hurt
        @hurt_sound.play
      when :atack
        @atack_sound.play
      end
    end

    private

    def set_effect
      @shadow = Sprite.new(
        'assets/images/MediumShadow.png',
        width: 15,
        height: 12,
        z: z - 1,
        opacity: 1
      )

      @hurt_sound = Sound.new('assets/sounds/Hurt.wav')
      @atack_sound = Sound.new('assets/sounds/Swipe.wav')
      @evade_sound = Sound.new('assets/sounds/Evade.wav')
    end

    def set_collision
      @collision = Rectangle.new(
        x: x + 26, y: y + 40,
        width: 10, height: 5,
        color: 'black',
        opacity: @collision_opacity,
        z: 20
      )

      @hit_box = Rectangle.new(
        x: x + 38, y: y + 24,
        width: 10, height: 20,
        color: 'red',
        opacity: @collision_opacity,
        z: 20
      )
      @hurt_box = Rectangle.new(
        x: x + 26, y: y + 40,
        width: 10, height: 5,
        color: 'orange',
        opacity: @collision_opacity,
        z: 20
      )
    end

    def move_collision
      @hurt_box.x = @collision.x = x + 26
      @hurt_box.y = @collision.y = y + 40

      @shadow.x = x + 24
      @shadow.y = y + 36
      @shadow.z = z
      set_hit_box_direction @direction.to_sym
    end

    def set_hit_box_direction(direction)
      @hit_box.x = x + HIT_BOX_POSITIONS[direction][:x]
      @hit_box.y = y + HIT_BOX_POSITIONS[direction][:y]
      @hit_box.width = HIT_BOX_POSITIONS[direction][:width]
      @hit_box.height = HIT_BOX_POSITIONS[direction][:height]
    end
  end
end
