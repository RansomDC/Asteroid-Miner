extends CanvasLayer

@onready var color_rect = $ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.color.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func fade(target_alpha: float, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween
