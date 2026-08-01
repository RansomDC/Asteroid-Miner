class_name Level extends Node

# Reference Nodes
@onready var player = $Player
@onready var playerSpawnArea = $PlayerSpawnPosition/PlayerSpawnLocation
@onready var asteroids = $Asteroids
@onready var lasers = $Lasers

# Data
@onready var viewport = get_viewport()

# Preloads
@onready var asteroid_lg = preload("res://Scenes/Asteroids/asteroid_lg.tscn")
@onready var asteroid_md = preload("res://Scenes/Asteroids/asteroid_md.tscn")
@onready var asteroid_sm = preload("res://Scenes/Asteroids/asteroid_sm.tscn")

# Variables
var _lives := 3
var num_asteroids = 3

var lives:
	set(value):
		_lives = value
		#TODO: implement HUD
		#hud.lives = _lives
		#hud.init_lives(_lives)
	get:
		return _lives

func _ready():
	player.connect("died", _on_player_died)
	
	#This spawns asteroids in random positions when the level is loaded
	for i in num_asteroids:
		var new_asteroid = asteroid_lg.instantiate()
		new_asteroid.position = get_random_position()
		new_asteroid.lg_destroyed.connect(_on_lg_asteroid_destroyed)
		asteroids.add_child(new_asteroid)

func _on_player_died():
	lives -= 1
	if lives <= 0:
		await get_tree().create_timer(2).timeout
		#TODO: implement game over screen
		#gameOverScreen.visible = true
	else:
		await get_tree().create_timer(2.5).timeout
#		Check if the spawn area is free of asteroids
		while !playerSpawnArea.is_empty:
			await get_tree().create_timer(0.1).timeout
		player.respawn()
		player.global_position = playerSpawnArea.global_position
	

func _on_lg_asteroid_destroyed(position):
	for i in 2:
		var a = asteroid_md.instantiate()
		a.md_destroyed.connect(_on_md_asteroid_destroyed)
		a.position = position
		asteroids.add_child(a)
		

func _on_md_asteroid_destroyed(position):
	for i in 2:
		var a = asteroid_sm.instantiate()
		a.position = position
		asteroids.add_child(a)
		

#func _on_sm_asteroid_destroyed(position):
#	for i in 2:
#		var a = asteroid_md.instantiate()
#		a.position = position
#		asteroids.add_child(a)
		

# Helpers
func get_random_position():
	randomize()
	#return a random screen position
	var v = Vector2(randf_range(0, viewport.get_visible_rect().size.x), randf_range(0, viewport.get_visible_rect().size.y))
	return v


func _on_player_laser_fired(laser):
	lasers.add_child(laser)
