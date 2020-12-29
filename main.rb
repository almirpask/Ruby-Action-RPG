require 'ruby2d'
require_relative 'lib/graphics/background'
require_relative 'lib/graphics/tree'
require_relative 'lib/graphics/grass'
require_relative 'lib/logic/player'
require_relative 'lib/logic/enemy'
require_relative 'lib/logic/collision_manager'

set title: 'Action RPG', fullscreen: false, resizable: false, width: 1280, height: 720, viewport_width: 320, viewport_height: 180, background: 'white'
SHOW_COLLISIONS = 1 # 1 TRUE, 0 FALSE
collision_opacity = 0

case SHOW_COLLISIONS
when 0
  collision_opacity = 0
when 1
  collision_opacity = 0.5
end

collision_manager = Logic::CollisionManager.new
collision_manager.add_object Graphics::Tree.new(x: 55, y: 21, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Tree.new(x: 110, y: 50, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Tree.new(x: 210, y: 50, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Tree.new(x: 150, y: 90, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Grass.new(x: 0, y: 0, collision_opacity: collision_opacity)
collision_manager.add_enemy Logic::Enemy.new(collision_opacity: collision_opacity)
Graphics::Background.new(get(:window))
@player = Logic::Player.new(collision_opacity: collision_opacity)

on :key_up do |event|
  key = event.key
  @player.reset_position key
end

on :key_down do |event|
  key = event.key
  @player.atack key
  @player.move key
end

on :key do |event|
  key = event.key
  @player.move key
end

update do
  @player.state_machine
  collision = collision_manager.collision? @player.sprite.collision
  collision_manager.destructible? @player
  @player.is_colliding = collision
  ysort = collision_manager.ysort? @player.sprite.collision
  collision_manager.player_detection_zone? @player
  @player.sprite.z = if ysort
                       4
                     else
                       20
                     end
end
show
