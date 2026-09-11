class_name MainGame
extends Node

## Main entry point for the game.
## Responsible for setting up teh World layers and coordinating high-level systems


# TODO: main menu
const LEVEL_SCENE_UID  : String = "uid://cuvxplv7nn65r"
const PLAYER_SCENE_UID : String = "uid://bovh403sqglwm"
const HUD_SCENE_UID    : String = "uid://dnof5csgfeu1f"

var player         : Player = null
var asteroid       : Destructor = null
var hud            : Control = null

var _current_level : BaseLevel = null

# Game World root nodes
@onready var level_root  : Node2D = $World/LevelRoot
@onready var entity_root : Node2D = $World/EntityRoot
@onready var effect_root : Node2D = $World/EffectRoot

# UI Root Nodes
@onready var hud_root        : Control = $HudLayer/HudRoot
@onready var pause_root      : Control = $PauseLayer/PauseRoot
@onready var transition_root : Control = $TransitionLayer/TransitionRoot

# Preload Scenes
@onready var asteroid_lg = preload("res://Scenes/Asteroids/asteroid_lg.tscn")
@onready var asteroid_md = preload("res://Scenes/Asteroids/asteroid_md.tscn")
@onready var asteroid_sm = preload("res://Scenes/Asteroids/asteroid_sm.tscn")
@onready var laser       = preload("res://Scenes/Laser/laser.tscn")


func _ready() -> void:
	_init_player()
	
	_init_hud()
	
	load_level(LEVEL_SCENE_UID)
	

func _init_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load playerscene: " + PLAYER_SCENE_UID)
		return
	
	player = player_scene.instantiate() as Player
	player.laser_fired.connect(_on_laser_fired)
	if player == null:
		push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_UID)
		return
	
	entity_root.add_child(player)

func _init_hud() -> void:
	var hud_scene : PackedScene = ResourceLoader.load(HUD_SCENE_UID) as PackedScene
	if hud_scene == null:
		push_error("Could not load hudscene: " + HUD_SCENE_UID)
		return
	
	hud = hud_scene.instantiate() as Control
	if hud == null:
		push_error("Loaded hud scene does not extend Control or DNE: " + HUD_SCENE_UID)
		return
	
	hud_root.add_child(hud)

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

	_current_level.request_lg_ass_spawn.connect(_on_request_lg_ass_spawn)
	
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

func _on_laser_fired(position : Vector2, rotation : float):
	var l = laser.instantiate()
	l.global_position = position
	l.rotation = rotation
	entity_root.add_child(l)

func _on_request_lg_ass_spawn(locations : Array):
	for location in locations:
		var new_asteroid = asteroid_lg.instantiate()
		new_asteroid.parent_asteroid_destroyed.connect(_on_parent_ass_destroyed)
		new_asteroid.position = location
		entity_root.add_child(new_asteroid)

func _on_parent_ass_destroyed(position : Vector2, asteroidType : Destructor):
	if asteroidType is Asteroid_lg:
		for ass in 2:
			var new_asteroid = asteroid_md.instantiate()
			new_asteroid.parent_asteroid_destroyed.connect(_on_parent_ass_destroyed)
			new_asteroid.position = position
			entity_root.call_deferred("add_child", new_asteroid)
			
	if asteroidType is Asteroid_md:
		for ass in 2:
			var new_asteroid = asteroid_sm.instantiate()
			new_asteroid.position = position
			entity_root.call_deferred("add_child", new_asteroid)











