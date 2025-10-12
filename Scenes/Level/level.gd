class_name Level extends Node

@onready var player = $Player
@onready var playerSpawnArea = $PlayerSpawnPosition/PlayerSpawnLocation

var _lives := 3

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
	
