require 'ruby2d'

class Graphics
  class Enemy < Sprite
    attr_accessor :hit_box, :player_zone_detection, :collision, :hurt_box, :shadow
    attr_reader :collision_opacity

    def initialize(collision_opacity: 0, x:, y:)
      dimensions = {
        width: 16,
        height: 24
      }
      z = 40
      super(
        'assets/images/Bat.png',
        clip_width: dimensions[:width],
        **dimensions,
        x: x,
        y: y,
        z: z,
        time: 110,
        loop: true
      )

      @collision_opacity = collision_opacity

      set_collision
      set_effects
    end

    def x=(number)
      super
      @x = number
      move
    end

    def y=(number)
      super
      @y = number
      move
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

    def play_effect(effect)
      case effect
      when :death
        @death_effect.opacity = 1
        @death_effect_sound.play
        @death_effect.play do
          @death_effect.opacity = 0
        end
      when :hit
        @hit_effect.opacity = 1
        @hit_effect_sound.play
        @hit_effect.play do
          @hit_effect.opacity = 0
        end
      end
    end

    private

    def move
      move_effects
      move_collision
    end

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
    end

    def move_effects
      @hit_effect.x = x - 5
      @hit_effect.y = y - 5
      @death_effect.x = x - 8
      @death_effect.y = y - 8
      @shadow.x = x + 4
      @shadow.y = y + 18
      @shadow.z = z
    end

    def set_effects
      @shadow = Sprite.new(
        'assets/images/SmallShadow.png',
        width: 10,
        height: 8,
        x: x + 4,
        y: y + 18,
        z: z,
        opacity: opacity
      )

      @hit_effect = Sprite.new(
        'assets/images/HitEffect.png',
        clip_width: 24,
        width: 24,
        height: 24,
        time: 110,
        x: x - 5,
        y: y - 5,
        z: z + 1,
        opacity: 0
      )

      @hit_effect_sound = Sound.new('assets/sounds/Hit.wav')

      @death_effect = Sprite.new(
        'assets/images/EnemyDeathEffect.png',
        clip_width: 32,
        width: 32,
        height: 32,
        time: 110,
        x: x - 8,
        y: y - 8,
        z: z,
        opacity: 0
      )

      @death_effect_sound = Sound.new('assets/sounds/EnemyDie.wav')
    end
  end
end
