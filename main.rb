require 'ruby2d'
require_relative 'lib/graphics/background'
require_relative 'lib/graphics/tree'
require_relative 'lib/logic/player'
require_relative 'lib/logic/collision_manager'

set fullscreen: false, resizable: false, width: 1280, height: 720, viewport_width: 320, viewport_height: 180, background: 'white'
collision_manager = Logic::CollisionManager.new
collision_manager.add_object Graphics::Tree.new(x: 55, y: 21)
collision_manager.add_object Graphics::Tree.new(x: 110, y: 50)
collision_manager.add_object Graphics::Tree.new(x: 210, y: 50)
collision_manager.add_object Graphics::Tree.new(x: 150, y: 90)
Graphics::Background.new(get(:window))

@player = Logic::Player.new

on :key_up do |event|
  key = event.key
  @player.reset_position key
end

on :key do |event|
  key = event.key
  @player.move key
end

update do
  @player.state_machine
  collision = collision_manager.collision? @player.sprite.collision
  @player.is_colliding = collision
  ysort = collision_manager.ysort? @player.sprite.collision
  puts ysort
  @player.sprite.z = if ysort
                       4
                     else
                       20
                     end
end
show
