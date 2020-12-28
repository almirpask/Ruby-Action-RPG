require 'ruby2d'
require_relative '../graphics/enemy.rb'

class Logic
  class Enemy
    attr_accessor :sprite
    def initialize
      @sprite = Graphics::Enemy.new
      @sprite.play
    end
  end
end
