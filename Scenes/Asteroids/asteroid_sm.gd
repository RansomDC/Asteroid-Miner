class_name Asteroid_sm extends Destructor

# Components
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $CollisionShape2D

var asteroid_size = 32

func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		destructionComponent.destroy()
