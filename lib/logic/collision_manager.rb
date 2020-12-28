class Logic::CollisionManager
  attr_accessor :collisions, :ysorts

  def initialize
    @collisions = []
    @ysorts = []
  end

  def collision?(player)
    check_overlap @collisions, player
  end

  def ysort?(player)
    check_overlap @ysorts, player
  end

  def add_object(object)
    @collisions << object.collision unless object.collision.nil?
    @ysorts << object.ysort unless object.ysort.nil?
  end

  private

  def check_overlap(objects, player)
    Array(objects).any? do |object|
      horizontal_overlap(player, object) && vertical_overlap(player, object)
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
