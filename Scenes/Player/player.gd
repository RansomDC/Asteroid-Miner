class_name Player extends CharacterBody2D

signal died

@export var MAX_SPEED = 540
@export var speed = 30
@export var turn_speed = 5
@export var explode_rotation = 3
@export var rotation_direction = 0
@export var ship_size = 45

@onready var collisionShape = $PlayerArea/PlayerCollisionPoly
@onready var shipParts = getShipParts()

var rng = RandomNumberGenerator.new()
var spinning_speeds = [-3, -2, 2, 3]

var playerIsDead = false
var deathMomentumDirection = Vector2.ZERO

func _process(delta):
	
	#Ship Explode Logic
	if playerIsDead == true:
		_explode_action(delta)
	
	if Input.is_action_just_pressed("explodeTest"):
		print(velocity.angle())
		explode_test(delta)

func _physics_process(delta):
	
	get_input()
	if !playerIsDead:
		rotation += rotation_direction * turn_speed * delta
	
	move_and_slide()
	
	traverse_edge(get_viewport_rect().size)

#region Movement and Location
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
#endregion

func explode_test(delta):
	pass
	

func _on_player_area_area_entered(area):
	print(area.get_class())
	if (area is Destructor) && (!playerIsDead):
		die(area)

func die(killer):
	if !playerIsDead:
		playerIsDead = true
		emit_signal("died")
	# get killer (e.g. asteroid) angle of movenet
	deathMomentumDirection = killer.velocity
	collisionShape.set_deferred("disabled", true)
	
func respawn():
	if playerIsDead:
		playerIsDead = false
	
	velocity = Vector2.ZERO
	#re-enable the player
	collisionShape.set_deferred("disabled", false)

#region Ship destruction animation logic
func getShipParts():
	var playerChildren = get_children()
	var result = []
	for child in playerChildren:
		if child.is_class("Line2D"):
			result.append(child)
	return result

func _explode_action(delta):
	# First Make the ship stop moving
	velocity = Vector2.ZERO
	# Set the ships rotation to default
	rotation = 0
	
	# For each part, set the angle of its movement after death
	for part in shipParts:
		
		# If the ship part doesn't have a random value set for the dispersal direction give it one
		if part.disperseDirection == Vector2.ZERO:
			part.disperseDirection = deathMomentumDirection + Vector2(rng.randf_range(-40, 40), rng.randf_range(-40, 40))
			
		# If the ship part doesn't have a random value set for the dispersal rotation give it one
		if part.disperseRotation == 0:
			part.disperseRotation = spinning_speeds.pick_random()
			
		# disperse the parts over time
		part.position.x += part.disperseDirection.x * 1 * delta
		part.position.y += part.disperseDirection.y * 1 * delta
		# rotate the parts over time
		part.rotation += part.disperseRotation * delta
		
		# Make the parts fade out
		part.default_color.a8 -= 1
#endregion
