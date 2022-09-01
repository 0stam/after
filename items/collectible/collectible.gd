extends Node3D

var actions: Array[Dictionary] = [{"type": "weapon", "path": "res://weapons/knife/knife.tscn"}]


# Called by a player on a raycast hit
func action() -> void:
	for action in actions:
		match action["type"]:
			"dialogue":
				References.player.start_dialogue(action["owner"])
			"weapon":
				References.player.change_weapon(action["path"])
	
	queue_free()
