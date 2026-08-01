class_name Asteroid_md extends Destructor

# Signals
signal md_destroyed(position)

# Components
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $CollisionShape2D

var asteroid_size = 64

func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		collisionShape.set_deferred("disabled", true)
		destructionComponent.destroy()
		md_destroyed.emit(self.global_position)
