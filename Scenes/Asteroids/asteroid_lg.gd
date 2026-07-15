class_name Asteroid_lg extends Destructor

@onready var navigateScreen = $NavigateScreenComponent
@onready var destructionComponent = $DestructionComponent

var asteroid_size = 88

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	#Move asteroid to other side of screen when they go off one side
	global_position = navigateScreen.traverse_edge(get_viewport_rect().size, global_position, asteroid_size)
