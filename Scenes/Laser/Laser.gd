class_name Laser extends Area2D

@export var speed := 550.0
@export var size = 5

@onready var navigateScreen = $NavigateScreenComponent

var movement_vector := Vector2(0, -1)

## Provide the movement for the laser, movement respects the rotational angle of the Laser Area2D
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	#Move laser to other side of screen when they go off one side
	global_position = navigateScreen.traverse_edge(get_viewport_rect().size, global_position, size)

func _on_timer_timeout():
	queue_free()
