require 'ruby2d'
require_relative '../graphics/player.rb'

class Logic
  class Player
    attr_accessor :state, :position, :flip, :player, :direction, :current_state, :last_position, :is_colliding, :atack_finished
    attr_reader :damage, :health_points, :max_health_points
    def initialize(collision_opacity: 0)
      @player = Graphics::Player.new(collision_opacity: collision_opacity)
      @state = :move
      @current_state = @state
      @flip = nil
      @position = { x: 0, y: 0 }
      @last_position = @position
      @direction = 'down'
      @player.direction = @direction
      @player.play(animation: "idle_#{@direction}".to_sym, loop: true)
      @is_colliding = false
      @damage = 1.0
      @atack_finished = true
      @max_health_points = 3
      @health_points = @max_health_points * 2

      Graphics::Hearth.new(max_health_points: max_health_points, health_points: @health_points)
    end

    def move(key)
      if %i[idle move].include? @state
        @current_state = :move
        @position[:x] = action_pressed?(key, 'right') - action_pressed?(key, 'left') if @position[:x].zero?
        @position[:y] = action_pressed?(key, 'down') - action_pressed?(key, 'up') if @position[:y].zero?

        @flip = :horizontal if @position[:x] < 0
        @flip = nil if @position[:x] > 0
        @state = :move if @position[:x] != 0 || @position[:y] != 0
      end
    end

    def atack(key)
      @state = :atack if key == 'z'
      @current_state = :atack if key == 'z'
    end

    def reset_position(key)
      if %w[left right].include?(key)
        position[:x] = 0
      elsif %w[up down].include?(key)
        position[:y] = 0
      end
    end

    def sprite
      @player
    end

    def state_machine
      case state
      when :idle
        idle_state
      when :move
        move_state
      when :roll
        roll_state
      when :atack
        atack_state
      end
    end

    private

    def idle_state
      return unless @current_state != @state

      @player.play(animation: "idle_#{@direction}".to_sym, loop: true)
      @current_state = @state
    end

    def move_state
      @position = normalize(@position)

      set_direction
      if is_colliding
        push = 3
        case @direction
        when 'up'
          @player.y += push
        when 'down'
          @player.y -= push
        when 'left'
          @player.x += push
        when 'right'
          @player.x -= push
        end
      else
        @player.x += @position[:x]
        @player.y += @position[:y]
      end
      @state = :idle
      @current_state = :move
    end

    def roll_state
      @current_state = @state
    end

    def atack_state
      @current_state = @state

      @player.play(animation: "atack_#{direction}".to_sym) do
        @state = :idle
        @atack_finished = true
      end
    end

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
      if @position[:y].zero?
        if @position[:x] < 0
          @player.play(animation: :move_left, loop: true)
          @direction = 'left'
        elsif @position[:x] > 0
          @player.play(animation: :move_right, loop: true)
          @direction = 'right'
        end
      end

      if @position[:y] < 0
        @player.play(animation: :move_up, loop: true)
        @direction = 'up'
      elsif @position[:y] > 0
        @player.play(animation: :move_down, loop: true)
        @direction = 'down'
      end
      @player.direction = @direction
    end
  end
end
