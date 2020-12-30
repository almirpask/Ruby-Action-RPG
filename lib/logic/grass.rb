require 'ruby2d'
require_relative '../graphics/grass.rb'

class Logic
  class Grass
    attr_accessor :ready_to_destroy
    def initialize(**args)
      @sprite = Graphics::Grass.new(**args)
      @ready_to_destroy = false
    end

    def destroy
      @sprite.destroy
    end

    def destructible
      @sprite.destructible
    end

    def collision
      @sprite.collision
    end
  end
end
