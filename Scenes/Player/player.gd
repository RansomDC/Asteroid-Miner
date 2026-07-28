class_name Player extends CharacterBody2D

# Signals
signal laser_fired(laser)
signal died

@export var MAX_SPEED = 540
@export var speed = 30
@export var turn_speed = 5
@export var explode_rotation = 3
@export var rotation_direction = 0
@export var ship_size = 45

# Components
@onready var playerDeath = $PlayerDeathComponent
@onready var navigateScreen = $NavigateScreenComponent
@onready var destructionComponent = $DestructionComponent

# Preloads
var laser_scene = preload("res://Scenes/Laser/laser.tscn")

@onready var collisionShape = $PlayerArea/PlayerCollisionPoly
@onready var cannon = $Cannon
@onready var shipParts = destructionComponent.getParts()

var rng = RandomNumberGenerator.new()
var spinning_speeds = [-3, -2, 2, 3]

var playerIsDead = false
var deathMomentumDirection = Vector2.ZERO

func _process(delta):
	
	if playerIsDead: return
	
	if Input.is_action_just_pressed("fire"):
		fire_laser()

func _physics_process(delta):
	
	get_input()
	if !playerIsDead:
		rotation += rotation_direction * turn_speed * delta
	
	move_and_slide()
	navScreen()

#region Movement and Location
func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	if (Input.is_action_pressed("ui_up")):
		accelerate()

func accelerate():
	velocity.y += transform.y.y * -speed
	velocity.x += transform.y.x * -speed
	velocity = velocity.limit_length(MAX_SPEED)

func navScreen():
	#Move player to other side of screen when they go off one side
	global_position = navigateScreen.traverse_edge(get_viewport_rect().size, global_position, ship_size)

#endregion

#region Laser
func fire_laser():
	var l = laser_scene.instantiate()
	l.global_position = cannon.global_position
	l.rotation = rotation
	emit_signal("laser_fired", l)



#endregion

func _on_player_area_area_entered(area):
	print(area.get_class())
	if (area is Destructor) && (!playerIsDead):
		die(area)

func die(killer):
	if !playerIsDead:
		playerIsDead = true
		destructionComponent.destroy()
		emit_signal("died")
	# get killer (e.g. asteroid) angle of movenet
	deathMomentumDirection = killer.velocity
	collisionShape.set_deferred("disabled", true)
	
func respawn():
	if playerIsDead:
		playerIsDead = false
		destructionComponent.regen()
	
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

