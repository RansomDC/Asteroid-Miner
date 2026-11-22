class_name Upgrade extends Node2D

# Node Refs
@onready var upgradeImage = $UpgradeImage
@onready var upgradeLabel = $UpgradeLabel

# Props
var upgrade_type : Enums.Upgrades = Enums.Upgrades.NONE
var upgrade_cost : int      = 0

var upgrade_image_path: String:
	set(value):
		upgradeImage.texture = load(value) as Texture2D

var upgrade_label: String:
	set(value):
		upgradeLabel.text = str(value)

# Constructor
func upgrade_constructor(upgradeType : Enums.Upgrades, upgradeCost : int, upgradeImagePath : String, upgradeLabel : String):
	upgrade_type = upgradeType
	upgrade_cost = upgradeCost
	upgrade_image_path = upgradeImagePath
	upgrade_label = upgradeLabel
