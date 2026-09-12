class_name Hud extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)


func update_score_label(totalPoints : int):
	score = totalPoints
