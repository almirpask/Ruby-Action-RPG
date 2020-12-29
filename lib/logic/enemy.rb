require 'ruby2d'
require_relative '../graphics/enemy.rb'

class Logic
  class Enemy
    attr_accessor :sprite
    VELOCITY = 0.5
    def initialize(collision_opacity: 0)
      @sprite = Graphics::Enemy.new(collision_opacity: collision_opacity)
      @sprite.play
    end

    def move_to_player_position(player)
      chase_target player.collision
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

      @sprite.x += position[:x] * VELOCITY
      @sprite.y += position[:y] * VELOCITY
    end
  end
end
