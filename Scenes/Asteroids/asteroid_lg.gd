class_name Asteroid_lg extends Destructor

# Signals
signal parent_asteroid_destroyed(position : Vector2, assType : Destructor)
signal update_score(points : int)

# Components
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $CollisionShape2D

var asteroid_size = 80

func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		destroy()
	
	if area.get_parent() is Player:
		destroy()

func destroy():
		collisionShape.set_deferred("disabled", true)
		destructionComponent.destroy()
		parent_asteroid_destroyed.emit(self.global_position, self)
		update_score.emit(150)
