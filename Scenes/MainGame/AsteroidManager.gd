extends Node

# Signals

# Node Refs
@onready var main_game        : MainGame = get_parent().get_parent()

# Preload Scenes
@onready var asteroid_lg  = preload("res://Scenes/Asteroids/asteroid_lg.tscn")
@onready var asteroid_md  = preload("res://Scenes/Asteroids/asteroid_md.tscn")
@onready var asteroid_sm  = preload("res://Scenes/Asteroids/asteroid_sm.tscn")

# Variables

# Tools
var rng = RandomNumberGenerator.new()


# Methods
func on_ass_destroyed(position : Vector2, asteroidType : Destructor):
	if asteroidType is Asteroid_lg:
		main_game.update_score(150)
		for ass in rng.randf_range(2, 3):
			main_game.on_spawn_asteroid_request([position], Asteroid_md)
	elif asteroidType is Asteroid_md:
		main_game.update_score(100)
		for ass in rng.randf_range(2, 4):
			main_game.on_spawn_asteroid_request([position], Asteroid_sm)
	elif asteroidType is Asteroid_sm:
		main_game.update_score(50)
		# Trigger a debounce timer that checks if the level is complete
		main_game.level_end_timer.start(3)
	
func setup_asteroid(newAsteroid : Destructor, location : Vector2):
	newAsteroid.asteroid_destroyed.connect(on_ass_destroyed)
	if newAsteroid is Asteroid_lg or newAsteroid is Asteroid_md:
		newAsteroid.spawn_crystal.connect(main_game.on_spawn_crystal)
	newAsteroid.position = location
	main_game.entity_root.call_deferred("add_child",newAsteroid)


# Helper Functions

