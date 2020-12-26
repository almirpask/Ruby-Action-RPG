require 'ruby2d'

class Graphics
  class Player < Sprite
    def initialize
      dimensions = {
        width: 64,
        height: 64
      }
      super(
        'assets/images/Player.png',
        clip_width: dimensions[:width],
        **dimensions,
        z: 1,
        animations: {
          idle: [
            { x: 0, y: 0, **dimensions, time: 100 }
          ],
          move_left: [
            { x: 64, y: 0, **dimensions, time: 100 },
            { x: 128, y: 0, **dimensions, time: 100 },
            { x: 192, y: 0, **dimensions, time: 100 },
            { x: 256, y: 0, **dimensions, time: 100 },
            { x: 320, y: 0, **dimensions, time: 100 },
            { x: 0, y: 0, **dimensions, time: 100 }
          ],
          move_right: [
            { x: 832, y: 0, **dimensions, time: 100 },
            { x: 986, y: 0, **dimensions, time: 100 },
            { x: 960, y: 0, **dimensions, time: 100 },
            { x: 1024, y: 0, **dimensions, time: 100 },
            { x: 1088, y: 0, **dimensions, time: 100 },
            { x: 768, y: 0, **dimensions, time: 100 }
          ],
          move_up: [
            { x: 448, y: 0, **dimensions, time: 100 },
            { x: 512, y: 0, **dimensions, time: 100 },
            { x: 576, y: 0, **dimensions, time: 100 },
            { x: 640, y: 0, **dimensions, time: 100 },
            { x: 704, y: 0, **dimensions, time: 100 },
            { x: 384, y: 0, **dimensions, time: 100 }
          ],
          move_down: [
            { x: 1216, y: 0, **dimensions, time: 100 },
            { x: 1280, y: 0, **dimensions, time: 100 },
            { x: 1344, y: 0, **dimensions, time: 100 },
            { x: 1408, y: 0, **dimensions, time: 100 },
            { x: 1472, y: 0, **dimensions, time: 100 },
            { x: 1152, y: 0, **dimensions, time: 100 }
          ]
        }
      )
    end
  end
end
