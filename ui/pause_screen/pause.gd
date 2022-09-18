extends Control


func toggle_pause() -> void:
	visible = not visible
	get_tree().paused = visible
	
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_resume_pressed() -> void:
	toggle_pause()


func _on_exit_pressed() -> void:
	toggle_pause()
	get_tree().change_scene("res://ui/title_screen/title_screen.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
