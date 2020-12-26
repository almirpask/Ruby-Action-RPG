require 'ruby2d'

class Graphics
  class Background < Sprite
    def initialize(window)
      super(
        'assets/images/GrassBackground.png',
        z: 0,
        clip_width: window.get(:width),
        clip_height: window.get(:height)
      )
    end
  end
end
