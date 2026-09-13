class_name Hud extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)

@onready var lives = $Lives:
	set(value):
		lives.text = "Lives: " + str(value)


func update_score_label(totalPoints : int):
	score = totalPoints

func update_lives_label(remainingLives : int):
	lives = remainingLives
