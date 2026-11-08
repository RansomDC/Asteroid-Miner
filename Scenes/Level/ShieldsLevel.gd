class_name ShieldsLevel extends BaseShop

# Signals
signal example_signal()

# Node Refs
@onready var exit = $Exit

# Props
var myExampleProp : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	exit.ShopName = "Exit"


func _on_exit_area_area_entered(area):
	send_leave_shop_request()
