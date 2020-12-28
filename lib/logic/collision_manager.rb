class Logic::CollisionManager
  attr_reader :collisions, :ysorts, :destructibles

  def initialize
    @collisions = []
    @ysorts = []
    @destructibles = []
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

  def add_object(object)
    @collisions << object.collision if object.respond_to?(:collision) && !object.destructible
    @destructibles << object if object.destructible
    @ysorts << object.ysort if object.respond_to? :ysort
  end

  private

  def check_overlap(objects, player)
    Array(objects).any? do |object|
      horizontal_overlap(player, object) && vertical_overlap(player, object)
    end
  end

  def check_overlap_and_destroy(objects, hit_box)
    @destructibles.each do |object|
      puts "object_id = #{object.object_id}"
    end
    puts '-------'
    @collisions.each do |object|
      puts "object_id = #{object.object_id}"
    end
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
