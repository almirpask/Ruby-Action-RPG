require 'ruby2d'
require_relative 'lib/graphics/background'
require_relative 'lib/logic/player'

set fullscreen: false, resizable: true, width: 1280, height: 720, viewport_width: 320, viewport_height: 180, background: 'white'

Graphics::Background.new(get(:window))
show
