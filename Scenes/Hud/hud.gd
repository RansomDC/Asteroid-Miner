class_name Hud extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)

@onready var level = $Level:
	set(value):
		level.text = "Level: " + str(value)

@onready var lives = $Lives:
	set(value):
		lives.text = "Lives: " + str(value)

@onready var shieldBar = $ShieldBar


func update_score_label(totalPoints : int):
	score = totalPoints

func update_level_label(currentLevel : int):
	level = currentLevel

func update_lives_label(remainingLives : int):
	lives = remainingLives

func update_shield_bar(health : int):
	shieldBar.value = health
