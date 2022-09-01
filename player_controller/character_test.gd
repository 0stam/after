extends Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # TODO: move to a proper game start script
	References.spawns = $Spawns
