require 'ruby2d'
require_relative '../graphics/enemy.rb'

class Logic
  class Enemy
    attr_accessor :sprite
    attr_reader :health_points, :max_health_points
    VELOCITY = 0.5
    def initialize(collision_opacity: 0)
      @sprite = Graphics::Enemy.new(collision_opacity: collision_opacity)
      @sprite.play
      @health_points = @max_health_points = 3
    end

    def health_points=(damage)
      @health_points = damage
      @sprite.remove if @health_points <= 0
    end

    def move_to_player_position(player)
      chase_target player.collision
    end

    def knocback(direction)
      force = 30
      case direction
      when 'up'
        @sprite.y -= force
      when 'down'
        @sprite.y += force
      when 'right'
        @sprite.x += force
      when 'left'
        @sprite.x -= force
      end
    end

    private

    def chase_target(player)
      position = { x: 0, y: 0 }
      if player.x > @sprite.collision.x
        position[:x] += 1
      elsif player.x < @sprite.collision.x
        position[:x] -= 1
      end

      if player.y > @sprite.collision.y
        position[:y] += 1
      elsif player.y < @sprite.collision.y
        position[:y] -= 1
      end

      @sprite.flip_sprite((:horizontal if position[:x] < 0))
      @sprite.x += position[:x] * VELOCITY
      @sprite.y += position[:y] * VELOCITY
    end
  end
end
