class_name ShopHubLevel extends BaseLevel

# Refs
#const LEVEL_SCENE_UID     : String = "uid://cuvxplv7nn65r"
const SHIELDS_SHOP_UID     : String = ""
const WEAPONS_SHOP_UID     : String = ""
const ENGINES_SHOP_UID     : String = ""


# Node Refs
@onready var ShieldStore = $ShieldStore
@onready var WeaponStore = $WeaponsStore
@onready var EngineStore = $EnginesStore
@onready var Exit        = $Exit

# Props
var myProp : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	ShieldStore.ShopName = "Shields"
	WeaponStore.ShopName = "Weapons"
	EngineStore.ShopName = "Engines"
	Exit.ShopName = "Exit"


func _on_shield_shop_area_area_entered(_area):
	request_scene_change.emit(SHIELDS_SHOP_UID)


func _on_weapons_shop_area_area_entered(_area):
	request_scene_change.emit(WEAPONS_SHOP_UID)


func _on_engines_shop_area_area_entered(_area):
	request_scene_change.emit(ENGINES_SHOP_UID)


func _on_exit_area_area_entered(_area):
	complete_current_level.emit()
