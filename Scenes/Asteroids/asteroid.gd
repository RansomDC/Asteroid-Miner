extends Node

@onready var navigateScreen = $NavigateScreenComponent
@onready var destructionComponent = $DestructionComponent
@onready var a = get_parent()

var movement_vector := Vector2(0,-1)
var speed := 50

# Called when the node enters the scene tree for the first time.
func _ready():
	a.rotation = randf_range(0, 3*PI)

func _physics_process(delta):
	a.global_position += movement_vector.rotated(a.rotation) * speed * delta
	
	#Move asteroid to other side of screen when they go off one side
	a.global_position = navigateScreen.traverse_edge(
		a.get_viewport_rect().size, 
		a.global_position, 
		a.asteroid_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
