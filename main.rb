require 'ruby2d'
require_relative 'lib/graphics/background'
require_relative 'lib/graphics/tree'
require_relative 'lib/graphics/Hearth'
require_relative 'lib/logic/player'
require_relative 'lib/logic/enemy'
require_relative 'lib/logic/collision_manager'
require_relative 'lib/logic/grass'

set title: 'Action RPG', fullscreen: false, resizable: false, width: 1280, height: 720, viewport_width: 320, viewport_height: 180, background: 'white'
SHOW_COLLISIONS = 1 # 1 TRUE, 0 FALSE
collision_opacity = 0
collision_opacity = 0.5 if SHOW_COLLISIONS == 1

collision_manager = Logic::CollisionManager.new
collision_manager.add_object Graphics::Tree.new(x: 55, y: 21, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Tree.new(x: 110, y: 50, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Tree.new(x: 210, y: 50, collision_opacity: collision_opacity)
collision_manager.add_object Graphics::Tree.new(x: 150, y: 90, collision_opacity: collision_opacity)
collision_manager.add_object Logic::Grass.new(x: 0, y: 0, collision_opacity: collision_opacity)

enemies = []
enemies << Logic::Enemy.new(collision_opacity: collision_opacity, x: 100, y: 100)
enemies << Logic::Enemy.new(collision_opacity: collision_opacity, x: 200, y: 130)
enemies << Logic::Enemy.new(collision_opacity: collision_opacity, x: 34, y: 70)
enemies.each do |enemy|
  collision_manager.add_enemy enemy
end

Graphics::Background.new(get(:window))
@player = Logic::Player.new(collision_opacity: collision_opacity)

on :key_up do |event|
  key = event.key
  @player.reset_position key
  close if key == 'esc'
end

on :key_down do |event|
  key = event.key
  @player.atack key
  @player.state = :evade if key == 'x'
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
  collision_manager.ysort? [@player, *enemies]
  collision_manager.player_detection_zone? @player
  collision_manager.attack_collision? @player
end
show
