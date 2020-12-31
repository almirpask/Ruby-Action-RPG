class Logic::CollisionManager
  attr_reader :collisions, :ysorts, :destructibles, :enemies

  def initialize
    @collisions = []
    @ysorts = []
    @destructibles = []
    @enemies = []
  end

  def attack_collision?(player)
    check_player_hit_box_overlap(player) if player.state == :atack && player.atack_finished
    check_enemy_hit_box_overlap(player) if player.health_points > 0
  end

  def collision?(player)
    objects = destructibles.map(&:collision)
    check_overlap [*@collisions, *objects], player
  end

  def ysort?(characters)
    characters.each do |character|
      next unless character.health_points > 0

      character.sprite.z = if check_overlap @ysorts, character.sprite.collision
                             4
                           else
                             40
                           end
    end
  end

  def destructible?(player)
    check_overlap_and_destroy @destructibles, player.sprite.hit_box if player.state == :atack
  end

  def player_detection_zone?(player)
    check_for_detections @enemies, player
  end

  def add_object(object)
    @collisions << object.collision if object.respond_to?(:collision) && !object.destructible
    @destructibles << object if object.destructible
    @ysorts << object.ysort if object.respond_to? :ysort
  end

  def add_enemy(enemy)
    @enemies << enemy
  end

  private

  def check_player_hit_box_overlap(player)
    player.atack_finished = false
    @enemies.each do |enemy|
      player_hit_box = player.sprite.hit_box
      enemy_hurt_box = enemy.sprite.hurt_box
      has_overlap = horizontal_overlap(player_hit_box, enemy_hurt_box) && vertical_overlap(player_hit_box, enemy_hurt_box)
      next unless has_overlap

      enemy.health_points -= player.damage

      enemy.knocback player.direction if enemy.health_points > 0
    end
    @enemies = @enemies.filter { |enemy| enemy.health_points > 0 }
  end

  def check_enemy_hit_box_overlap(player)
    @enemies.each do |enemy|
      player_hurt_box = player.sprite.hurt_box
      enemy_hit_box = enemy.sprite.hit_box
      has_overlap = horizontal_overlap(player_hurt_box, enemy_hit_box) && vertical_overlap(player_hurt_box, enemy_hit_box)
      next unless has_overlap

      player.health_points -= player.damage
    end
  end

  def check_for_detections(enemies, player)
    enemies.each do |enemy|
      player_collision = player.sprite.collision
      enemy_collision = enemy.sprite.player_zone_detection
      has_overlap = horizontal_overlap(player_collision, enemy_collision) && vertical_overlap(player_collision, enemy_collision)
      next unless has_overlap

      enemy.move_to_player_position player.sprite
    end
  end

  def check_overlap(objects, player)
    Array(objects).any? do |object|
      horizontal_overlap(player, object) && vertical_overlap(player, object)
    end
  end

  def check_overlap_and_destroy(objects, hit_box)
    objects.each do |object|
      has_overlap = horizontal_overlap(hit_box, object.collision) && vertical_overlap(hit_box, object.collision)
      next unless has_overlap

      object.ready_to_destroy = true
      object.destroy
    end

    @destructibles = @destructibles.filter { |object| object.ready_to_destroy == false }
  end

  def horizontal_overlap(player, object)
    player.x + player.width > object.x &&
      player.x < object.x + object.width
  end

  def vertical_overlap(player, object)
    object.y + object.height > player.y &&
      object.y < player.y + player.height
  end
end
