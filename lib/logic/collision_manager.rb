class Logic::CollisionManager
  attr_reader :collisions, :ysorts, :destructibles, :enemies

  def initialize
    @collisions = []
    @ysorts = []
    @destructibles = []
    @enemies = []
  end

  def collision?(player)
    objects = destructibles.map(&:collision)
    check_overlap [*@collisions, *objects], player
  end

  def ysort?(player)
    check_overlap @ysorts, player
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
    objects.each_with_index do |object, index|
      has_overlap = horizontal_overlap(hit_box, object.collision) && vertical_overlap(hit_box, object.collision)
      next unless has_overlap

      object.destroy
      @destructibles = @destructibles.pop index
    end
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
