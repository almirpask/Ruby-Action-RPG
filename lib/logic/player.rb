require 'ruby2d'
require_relative '../graphics/player.rb'

class Logic
  class Player
    attr_accessor :state, :direction, :atack_finished
    attr_writer :is_colliding
    attr_reader :damage, :health_points, :sprite
    def initialize(collision_opacity: 0)
      @sprite = Graphics::Player.new(collision_opacity: collision_opacity)
      @state = :move
      @current_state = @state
      @velocity = { x: 0, y: 0 }
      @direction = 'down'
      @is_colliding = false
      @damage = 1.0
      @atack_finished = true
      @max_health_points = 3
      @health_points = @max_health_points * 2
      @invencibility_timer = Time.now
      @heath_ui = Graphics::Hearth.new(max_health_points: @max_health_points, health_points: @health_points)
      @is_rolling = false

      @sprite.direction = @direction
      @sprite.play(animation: "idle_#{@direction}".to_sym, loop: true)
    end

    def move(key)
      if %i[idle move].include? @state
        @velocity[:x] = action_pressed?(key, 'right') - action_pressed?(key, 'left') if @velocity[:x].zero?
        @velocity[:y] = action_pressed?(key, 'down') - action_pressed?(key, 'up') if @velocity[:y].zero?
        @state = :move if @velocity[:x] != 0 || @velocity[:y] != 0
      end
    end

    def atack(key)
      @state = :atack if key == 'z'
      @current_state = :atack if key == 'z'
    end

    def reset_position(key)
      if %w[left right].include?(key)
        @velocity[:x] = 0
      elsif %w[up down].include?(key)
        @velocity[:y] = 0
      end
    end

    def state_machine
      case state
      when :idle
        idle_state
      when :move
        move_state
      when :evade
        evade_state
      when :atack
        atack_state
      when :dead
        dead_state
      end
    end

    def health_points=(damage)
      if Time.now - @invencibility_timer >= 1 && !@is_rolling
        @invencibility_timer = Time.now
        @sprite.play_sound :hurt
        @health_points = damage
        @heath_ui.health_points = @health_points
        @sprite.remove if @health_points <= 0
        @state = :dead if @health_points <= 0
      end
    end

    private

    def idle_state
      return unless @current_state != @state

      @sprite.play(animation: "idle_#{@direction}".to_sym, loop: true)
      @current_state = @state
    end

    def move_state
      @velocity = normalize(@velocity)

      set_direction
      if @is_colliding
        push = 3
        case @direction
        when 'up'
          @sprite.y += push
        when 'down'
          @sprite.y -= push
        when 'left'
          @sprite.x += push
        when 'right'
          @sprite.x -= push
        end
      else
        @sprite.x += @velocity[:x]
        @sprite.y += @velocity[:y]
      end
      @state = :idle
      @current_state = :move
    end

    def evade_state
      push = 2
      case @direction
      when 'up'
        @sprite.y -= push
      when 'down'
        @sprite.y += push
      when 'left'
        @sprite.x -= push
      when 'right'
        @sprite.x += push
      end

      @sprite.play_sound(:evade) unless @is_rolling
      @is_rolling = true
      @sprite.play(animation: "roll_#{@direction}".to_sym) do
        @state = :move
        @current_state = :evade
        @is_rolling = false
      end
    end

    def atack_state
      @current_state = @state
      @sprite.play_sound :atack if @atack_finished
      @sprite.play(animation: "atack_#{direction}".to_sym) do
        @state = :idle
        @atack_finished = true
      end
    end

    def dead_state; end

    def action_pressed?(key, action)
      key == action ? 1 : 0
    end

    def normalize(vector)
      new_vector = vector
      l = vector[:x] * vector[:x] + vector[:y] * vector[:y]
      if l != 0
        l = Math.sqrt(l)
        new_vector[:x] /= l
        new_vector[:y] /= l
        new_vector
      else
        vector
      end
    end

    def set_direction
      if @velocity[:y].zero?
        if @velocity[:x] < 0
          @sprite.play(animation: :move_left, loop: true)
          @direction = 'left'
        elsif @velocity[:x] > 0
          @sprite.play(animation: :move_right, loop: true)
          @direction = 'right'
        end
      end

      if @velocity[:y] < 0
        @sprite.play(animation: :move_up, loop: true)
        @direction = 'up'
      elsif @velocity[:y] > 0
        @sprite.play(animation: :move_down, loop: true)
        @direction = 'down'
      end
      @sprite.direction = @direction
    end
  end
end
