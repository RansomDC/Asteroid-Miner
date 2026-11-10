class_name Storefront extends Node2D

# Node Refs
@onready var ShopName = $ShopName:
	set(value):
		ShopName.text = str(value)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
