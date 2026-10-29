class_name CountScoreLevel extends BaseLevel

signal reset_level_score()
signal set_overall_score()

var currentScore = 0
var levelScore   = 0

@onready var overall_score_value_label : Label = $Scores/OverallScoreValue
@onready var level_score_value_label   : Label = $Scores/LevelScoreValue

# Called when the node enters the scene tree for the first time.
func _ready():
	overall_score_value_label.text = str(currentScore)
	level_score_value_label.text = str(levelScore)
	
	await get_tree().create_timer(2.0).timeout
	transfer_points()

func transfer_points() -> void:
	var source_start := int(level_score_value_label.text)
	var target_start := int(overall_score_value_label.text)
	
	if source_start <= 0:
		overall_score_value_label.text = "0"
		return
	
	var tween := create_tween().set_parallel(true)
	
	tween.tween_method(
		func(value: float) -> void:
			overall_score_value_label.text = str(roundi(value)),
		float(target_start),
		float(target_start + source_start),
		2.0
	)
	
	tween.tween_method(
		func(value: float) -> void:
			level_score_value_label.text = str(roundi(value)),
		float(source_start),
		0.0,
		2.0
	)
	
	
	# Guarantee exact final values when the naimation completes
	tween.chain().tween_callback(func() -> void:
		level_score_value_label.text = "0"
		overall_score_value_label.text = str(target_start + source_start)
	)
