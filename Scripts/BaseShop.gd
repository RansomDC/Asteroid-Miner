class_name BaseShop extends BaseLevel

const SHOP_HUB_UID : String = "uid://bjo3rstmax8wa"

func send_leave_shop_request()-> void:
	request_scene_change.emit(SHOP_HUB_UID)
