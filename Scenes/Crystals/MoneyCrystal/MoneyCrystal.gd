class_name MoneyCrystal extends Area2D

signal crystal_destroyed()

@onready var collision_shape        = $CollisionShape
@onready var destruction_component  = $DestructionComponent
@onready var navigateScreen         = $NavigateScreenComponent
@export var velocity: Vector2       = Vector2.ZERO

@onready var a = get_parent()

var movement_vector := Vector2(0,-1)
var speed := 50
var size = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = randf_range(0, 3*PI)

func _physics_process(delta):
	global_position += movement_vector.rotated(a.rotation) * speed * delta
	
	#Move to other side of screen when they go off one side
	global_position = navigateScreen.traverse_edge(
		get_viewport_rect().size, 
		global_position, 
		size)


func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		destroy()
	
	if area.get_parent() is Player:
		print("You got a crystal!")
		queue_free()
		#TODO: send a signal

func destroy():
		collision_shape.set_deferred("disabled", true)
		destruction_component.destroy()
#		crystal_destroyed.emit(self.global_position, self)
