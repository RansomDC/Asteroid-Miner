class_name Asteroid_lg extends Destructor

# Signals
signal lg_destroyed(position)

# Components
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $CollisionShape2D

var asteroid_size = 90
var speed := 50

func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		collisionShape.set_deferred("disabled", true)
		destructionComponent.destroy()
		lg_destroyed.emit(self.global_position)
