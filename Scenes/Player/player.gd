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

# Components
@onready var playerDeath = $PlayerDeathComponent
@onready var navigateScreen = $NavigateScreenComponent

var rng = RandomNumberGenerator.new()
var spinning_speeds = [-3, -2, 2, 3]

var playerIsDead = false
var deathMomentumDirection = Vector2.ZERO

func _process(delta):
	
	#Ship Explode Logic
	if playerIsDead == true:
		_explode_action(delta)

func _physics_process(delta):
	
	get_input()
	if !playerIsDead:
		rotation += rotation_direction * turn_speed * delta
	
	move_and_slide()
	
	global_position.y = navigateScreen.traverse_y(get_viewport_rect().size, global_position, ship_size)
	global_position.x = navigateScreen.traverse_x(get_viewport_rect().size, global_position, ship_size)

#region Movement and Location
func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	if (Input.is_action_pressed("ui_up")):
		accelerate()

func accelerate():
	velocity.y += transform.y.y * -speed
	velocity.x += transform.y.x * -speed
	velocity = velocity.limit_length(MAX_SPEED)

#endregion

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
	
	#Make the player visible and restore the ship parts
	for part in shipParts:
		part.position.x = 0
		part.position.y =0
		part.rotation = 0
		part.default_color.a8 = 255
		part.disperseDirection = Vector2.ZERO

###
#region Ship destruction animation logic
###
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
###
#endregion
###
