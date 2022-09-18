extends Control


func _on_new_game_pressed() -> void:
	get_tree().change_scene("res://player_controller/character_test.tscn")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
