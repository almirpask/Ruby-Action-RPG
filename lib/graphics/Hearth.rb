require 'ruby2d'

class Graphics
  class Hearth < Sprite
    def initialize(max_health_points:, health_points:)
      super(
        'assets/images/HeartUIEmpty.png',
        z: 100,
        x: 3,
        y: 3,
        clip_width: max_health_points * 15,
        clip_height: 11
      )

      @health_points = Sprite.new(
        'assets/images/HeartUIFull.png',
        z: 110,
        x: x,
        y: y,
        clip_width: health_points * 7.5,
        clip_height: 11
      )
    end

    def health_points=(health_points)
      @health_points.clip_width = health_points * 7.5
    end
  end
end
