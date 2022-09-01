extends Node3D
class_name Collectible

signal destroyed(name: String, chunk_name: String)

var chunk_name: String  # Assigned by the chunk system, allows to identify the collectible when destroyed

@export var actions: Array[Dictionary] = [{"type": "weapon", "path": "res://weapons/knife/knife.tscn"}]


# Called by a player on a raycast hit
func action() -> void:
	for action in actions:
		match action["type"]:
			"dialogue":
				References.player.start_dialogue(action["owner"])
			"weapon":
				References.player.change_weapon(action["path"])
	
	destroyed.emit(name, chunk_name)
	queue_free()


func _ready() -> void:
	for action in actions:
		match action["type"]:
			"weapon":
				add_child(load(action["path"]).instantiate())
