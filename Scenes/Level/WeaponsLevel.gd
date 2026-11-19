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
	
	safeShotUpgrade.upgrade_label = "Crystal Safe Shot"
	safeShotUpgrade.upgrade_image_path = "res://Assets/Images/CrystalSafeShot.png"
	
	triShotUpgrade.upgrade_label = "Tiple Shot"
	triShotUpgrade.upgrade_image_path = "res://Assets/Images/TripleShotIcon.png"
	
	longShotUpgrade.upgrade_label = "Long Shot"
	longShotUpgrade.upgrade_image_path = "res://Assets/Images/LongShotIcon.png"




func _on_exit_area_area_entered(area):
	if area.get_parent() is Player:
		send_leave_shop_request()
