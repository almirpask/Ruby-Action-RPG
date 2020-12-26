require 'ruby2d'
require_relative '../graphics/player.rb'

class Logic
  class Player
    attr_accessor :state, :position, :flip, :player, :direction, :current_state

    def initialize
      @player = Graphics::Player.new
      @state = :idle
      @current_state = @state
      @flip = nil
      @position = { x: 0, y: 0 }
      @direction = 'right'
    end

    def move(key)
      @position[:x] = action_pressed?(key, 'right') - action_pressed?(key, 'left') if @position[:x].zero?
      @position[:y] = action_pressed?(key, 'down') - action_pressed?(key, 'up') if @position[:y].zero?

      @flip = :horizontal if @position[:x] < 0
      @flip = nil if @position[:x] > 0
      @state = :move if @position[:x] != 0 || @position[:y] != 0
    end

    def action_pressed?(key, action)
      key == action ? 1 : 0
    end

    def idle_state
      if  @current_state != @state
        puts "idle_#{@direction}".to_sym
        @player.play(animation: "idle_#{@direction}".to_sym, loop: true)
        @current_state = @state
      end
    end

    def move_state
      @position = normalize(@position)
      @player.x += @position[:x]
      @player.y += @position[:y]
      if @position[:y] == 0
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
      @current_state = :move
    end

    def roll_state
      @current_state = @state
    end

    def atack_state
      @current_state = @state
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
  end
end

@player = Logic::Player.new

on :key_up do |event|
  key = event.key
  if %w[left right].include?(key)
    @player.position[:x] = 0
  elsif %w[up down].include?(key)
    @player.position[:y] = 0
  end
  @player.state = :idle if @player.position[:x].zero? && @player.position[:y].zero?
end

on :key do |event|
  key = event.key
  @player.move key
end

update do
  case @player.state
  when :idle
    @player.idle_state
  when :move
    @player.move_state
  when :roll
    @player.roll_state
  when :attack
    @player.atack_state
  end
end
