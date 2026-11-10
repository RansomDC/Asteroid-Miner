class_name WeaponsLevel extends BaseShop

# Signals
signal my_signal()

# Node Refs
@onready var exit = $Exit

# Props
var myProp : int = 0


func _ready():
	exit.ShopName = "Exit"




func _on_exit_area_area_entered(area):
	if area.get_parent() is Player:
		send_leave_shop_request()
