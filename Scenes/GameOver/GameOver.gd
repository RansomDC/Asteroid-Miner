class_name GameOverLevel extends BaseLevel

signal request_main_menu()

func _on_button_pressed():
	request_main_menu.emit()
