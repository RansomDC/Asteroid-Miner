class_name MainGame
extends Node

## Main entry point for the game.
## Responsible for setting up teh World layers and coordinating high-level systems


# TODO: main menu
const LEVEL_SCENE_UID  :String = "uid://cuvxplv7nn65r"
const PLAYER_SCENE_UID :String = "uid://bovh403sqglwm"

var player         : Player = null
var _current_level : BaseLevel = null

# Game World root nodes
@onready var level_root  :Node2D = $World/LevelRoot
@onready var entity_root :Node2D = $World/EntityRoot
@onready var effect_root :Node2D = $World/EffectRoot

# UI Root Nodes
@onready var hud_root        :Control = $HudLayer/HudRoot
@onready var pause_root      :Control = $PauseLayer/PauseRoot
@onready var transition_root :Control = $TransitionLayer/TransitionRoot

func _ready() -> void:
	_init_player()
	
	load_level(LEVEL_SCENE_UID)

func _init_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load playerscene: " + PLAYER_SCENE_UID)
		return
	
	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_UID)
		return
	
	entity_root.add_child(player)
	

## Called for loading a level scene.
## NOTE: The input level_scene must extend BaseLevel
func load_level(level_scene : String) -> void:
	# Make sure this is called during idle time
	_deferred_load_level.call_deferred(level_scene)

func _deferred_load_level(level_scene_uid : String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
	
	#Allow the old level to finish freeing before adding the new one
	await get_tree().process_frame
	
	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	
	if new_level_packed == null:
		push_error("Could not laod level as a packed scene: " + level_scene_uid)
		return
		#TODO (main menu) : Should have fall back scene
	
	_current_level = new_level_packed.instantiate() as BaseLevel
	
	level_root.add_child(_current_level)
	
	#Allow level to fully proces before accessing it
	await get_tree().process_frame
	_place_player_at_level_spawn()


## Finds the default spawn location in currently loaded leevl, and places
## the player at that position 
func _place_player_at_level_spawn() -> void:
	if player == null:
		push_error("Cannot place player in level because player is null")
		return
	if _current_level == null:
		push_error("Cannot place player into level because level is null")
		print("The current level is null")
		return
	
	player.global_position = _current_level.get_default_player_spawn()















