extends Node

signal request_scene_change(scene_uid: String)

const SHOP_HUB_UID : String = "uid://bjo3rstmax8wa"

func _on_exit_area_area_entered(area):
	request_scene_change.emit(SHOP_HUB_UID)
