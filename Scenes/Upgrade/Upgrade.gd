extends Node2D

# Node Refs
@onready var upgradeImage = $UpgradeImage
@onready var upgradeLabel = $UpgradeLabel

var upgrade_image_path: String:
	set(value):
		upgradeImage.texture = load(value) as Texture2D

var upgrade_label: String:
	set(value):
		upgradeLabel.text = str(value)


func _on_upgrade_area_area_entered(area):
	pass # Replace with function body.
