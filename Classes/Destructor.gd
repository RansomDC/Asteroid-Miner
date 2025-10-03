# The Destructor class allows a child that extends it to provide it's velocity
class_name Destructor extends Area2D

@export var velocity: Vector2 = Vector2.ZERO
var _last_position: Vector2

func _ready():
	_last_position = global_position

func _process(delta):
	velocity = (global_position-_last_position)/delta
	_last_position = global_position
