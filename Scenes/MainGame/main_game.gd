class_name MainGame
extends Node

## Main entry point for the game.
## Responsible for setting up teh World layers and coordinating high-level systems


# TODO: main menu
const LEVEL  :String = "res://Scenes/Level/level.tscn"
const PLAYER :String = "res://Scenes/Player/player.tscn"

# Game World root nodes
@onready var level_root  :Node2D = $World/LevelRoot
@onready var entity_root :Node2D = $World/EntityRoot
@onready var effect_root :Node2D = $World/EffectRoot

# UI Root Nodes
@onready var hud_root        :Control = $HudLayer/HudRoot
@onready var pause_root      :Control = $PauseLayer/PauseRoot
@onready var transition_root :Control = $TransitionLayer/TransitionRoot
