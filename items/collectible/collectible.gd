extends Node3D

var actions: Array[Dictionary] = [{"type": "dialogue", "owner": "test_entity"}]


# Called by a player on a raycast hit
func action() -> void:
	for action in actions:
		if action["type"] == "dialogue":
			References.player.start_dialogue(action["owner"])
