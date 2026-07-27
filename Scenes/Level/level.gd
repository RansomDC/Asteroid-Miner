class_name Level extends Node

@onready var player = $Player
@onready var playerSpawnArea = $PlayerSpawnPosition/PlayerSpawnLocation
@onready var viewport = get_viewport()
@onready var asteroids = $Asteroids
@onready var asteroid = preload("res://Scenes/Asteroids/asteroid_lg.tscn")

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
		var new_asteroid = asteroid.instantiate()
		new_asteroid.position = get_random_position()
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
	

# Helpers
func get_random_position():
	randomize()
	#return a random screen position
	var v = Vector2(randf_range(0, viewport.get_visible_rect().size.x), randf_range(0, viewport.get_visible_rect().size.y))
	return v
