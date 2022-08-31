extends Button
class_name DialogueButton

signal action_triggered(action: Array)
signal target_selected(target: String, option_text: String)

var data: Dictionary = {}


func initialize(new_data: Dictionary) -> void:
	data = new_data
	text = data["text"]


func _on_dialogue_button_pressed() -> void:
	if data.has("action"):
		action_triggered.emit(data["action"])
	if data.has("target"):
		target_selected.emit(data["target"], text)
