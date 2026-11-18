class_name Player extends CharacterBody2D

# Signals
signal laser_fired(position : Vector2, rotation : float)
signal update_health(health)
signal collect_health()
signal collect_money()
signal died

var MAX_SPEED = 540
var speed = 30
var turn_speed = 5
var rotation_direction = 0
var ship_size = 45
var maxHealth := 3
var health := 3

# Components
@onready var navigateScreen = $NavigateScreenComponent
@onready var destructionComponent = $DestructionComponent

# Node References
@onready var collisionShape = $PlayerArea/PlayerCollisionPoly
@onready var cannon = $Cannon

# Preloads
var laser_scene = preload("res://Scenes/Laser/laser.tscn")

@onready var shipParts = destructionComponent.getParts()

var is_disabled : bool = false
var playerIsDead = false
var deathMomentumDirection = Vector2.ZERO

func _ready():
	emit_signal("update_health", health)

func _process(_delta):
	
	if playerIsDead or is_disabled: 
		return
	
	if Input.is_action_just_pressed("fire"):
		fire_laser()
	
	if Input.is_action_just_pressed("debug_kill_player"):
		debug_kill_player()

func _physics_process(delta):
	
	if is_disabled:
		return
	
	get_input()
	
	if !playerIsDead or !is_disabled:
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
	laser_fired.emit(cannon.global_position, rotation)
#endregion

func _on_player_area_area_entered(area):
	# Player loses health when a destructive area enters it's area
	if (area is Destructor) && (!playerIsDead):
		health -= 1
		update_health.emit(health)
		if health < 0:
			die()
		
	# Player gains health (max of three) when a health crystal enters it's area
	elif area is HealthCrystal:
		if health < maxHealth:
			health += 1
		update_health.emit(health)
		print("You got a health crystal!")
		
	# Player gains money when a money crystal enters it's area
	elif area is MoneyCrystal:
		collect_money.emit()
		print("You got a money crystal!")
		
	elif area.get_parent() is Storefront:
		disable_ship()
		await get_tree().create_timer(1).timeout
		enable_ship()

func die():
	if !playerIsDead:
		playerIsDead = true
		destructionComponent.destroy()
		emit_signal("died")
	# get killer (e.g. asteroid) angle of movenet
	#deathMomentumDirection = killer.velocity

func disable_ship():
	velocity = Vector2(0,0)
	is_disabled = true

func enable_ship():
	is_disabled = false

func respawn():
	if playerIsDead:
		playerIsDead = false
	
	velocity = Vector2.ZERO

func reset_position():
	velocity = Vector2(0,0)
	rotation = 0

# Debug Methods
func debug_kill_player():
	die()












