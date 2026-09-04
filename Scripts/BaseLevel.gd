class_name BaseLevel extends Node

@onready var playerSpawn = $PlayerSpawnPosition

func get_default_player_spawn() -> Vector2:
	return playerSpawn.global_position
