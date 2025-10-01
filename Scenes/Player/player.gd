class_name Player extends CharacterBody2D

@export var MAX_SPEED = 540
@export var speed = 30
@export var rotation_speed = 5
@export var rotation_direction = 0
@export var ship_size = 45

@onready var sideOne = $sideOne

func _process(delta):
	
	if Input.is_action_just_pressed("explodeTest"):
		explode_test()

func _physics_process(delta):
	
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	
	move_and_slide()
	
	traverse_edge(get_viewport_rect().size)

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	if (Input.is_action_pressed("ui_up")):
		accelerate()

func accelerate():
	velocity.y += transform.y.y * -speed
	velocity.x += transform.y.x * -speed
	velocity = velocity.limit_length(MAX_SPEED)

# This set's the players location to the opposite side of the screen when they go past the edge.
func traverse_edge(screenSize):
	if (global_position.y + ship_size) < 0:
		global_position.y = (screenSize.y + ship_size)
	elif (global_position.y - ship_size) > screenSize.y:
		global_position.y = -ship_size
	if (global_position.x + ship_size) < 0:
		global_position.x = (screenSize.x + ship_size)
	elif (global_position.x - ship_size) > screenSize.x:
		global_position.x = -ship_size

func explode_test():
	sideOne.rotate(45)
