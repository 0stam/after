extends Control


var dialogue_data: Dictionary = {}  # All dialogues
var data: Dictionary = {}  # Current dialogue

var print_speed: float = 40

var option_button_scene: PackedScene = preload("res://dialogue/dialogue_button.tscn")

@onready var text_node: RichTextLabel = $VBoxContainer/Text
@onready var options_node: VBoxContainer = $VBoxContainer/Options  # Container for option buttons


# Add and animate text, returns a tween, making it possible to wait for the animation finish
func add_text(text: String) -> Tween:
	var visible_characters_start: float = text_node.get_total_character_count()
	text_node.text += text
	
	var tween: Tween = create_tween()
	var time: float = text_node.get_total_character_count() - visible_characters_start
	time /= print_speed
	tween.tween_property(text_node, "visible_characters",
						text_node.get_total_character_count(), time)
	
	return tween


# Display a line of dialog and create related option buttons
func display_line(id: String) -> void:
	for button in options_node.get_children():
		button.queue_free()

	var text: String = "[b]" + data["owner_name"] + ": [/b]"
	text += data["dialogue"][id]["text"] + "\n"
	await add_text(text).finished
	
	# Display options
	for option in data["dialogue"][id]["options"]:
		if PlotTracker.validate_condition(option["condition"]):
			var dialogue_button: DialogueButton = option_button_scene.instantiate()
			dialogue_button.initialize(option)
			dialogue_button.action_triggered.connect(_dialogue_button_action_triggered)
			dialogue_button.target_selected.connect(_dialogue_button_target_selected)
			
			options_node.add_child(dialogue_button)
			await get_tree().create_timer(0.2).timeout


func start_dialogue(owner: String) -> void:
	data = dialogue_data[owner]
	text_node.text = ""
	text_node.visible_characters = 0
	
	show()
	display_line(PlotTracker.get_option(data["start"]))
#	display_line(id)


func _dialogue_button_action_triggered(actions_array: Array) -> void:
	for action in actions_array:
		match action["type"]:
			"end":
				hide()
				References.player.end_dialogue()
			"set":
				PlotTracker.flags[action["flag"]] = action["val"]
			_:
				print("Unimplemented action type")


# Move to the next line
func _dialogue_button_target_selected(target: String, option_text: String) -> void:
	for button in options_node.get_children():
		button.queue_free()
	
	var tween: Tween = await add_text("[b]You: [/b]" + option_text + "\n")
	await tween.finished
	
	display_line(target)


func _ready() -> void:
	dialogue_data = Utils.parse_json("res://data/dialogues.json")
	References.player.dialogue_setup_finished.connect(start_dialogue)
