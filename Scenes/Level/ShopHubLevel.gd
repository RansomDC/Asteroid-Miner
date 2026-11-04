class_name ShopHubLevel extends BaseLevel

# Signals
signal my_signal()

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


