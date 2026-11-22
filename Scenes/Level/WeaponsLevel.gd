class_name WeaponsLevel extends BaseShop

# Signals


# Node Refs
@onready var exit             = $Exit
@onready var safeShotUpgrade  = $SafeShot
@onready var triShotUpgrade   = $TriShot
@onready var longShotUpgrade  = $LongShot

# Props
var myProp : int = 0


func _ready():
	exit.ShopName = "Exit"
	
	
	safeShotUpgrade.upgrade_constructor(Enums.Upgrades.SAFE_SHOT, 4, "res://Assets/Images/CrystalSafeShot.png", "Crystal Safe Shot")
	triShotUpgrade.upgrade_constructor(Enums.Upgrades.TRI_SHOT, 4, "res://Assets/Images/TripleShotIcon.png", "Triple Shot")
	longShotUpgrade.upgrade_constructor(Enums.Upgrades.LONG_SHOT, 3, "res://Assets/Images/LongShotIcon.png", "Long Shot")
	

func _on_exit_area_area_entered(area):
	if area.get_parent() is Player:
		send_leave_shop_request()
