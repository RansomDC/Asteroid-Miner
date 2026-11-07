class_name BaseLevel extends Node

# Signals
signal request_scene_change(scene_uid: String)
signal complete_current_level()

@onready var playerSpawn = $PlayerSpawnPosition

func get_default_player_spawn() -> Vector2:
	return playerSpawn.global_position
