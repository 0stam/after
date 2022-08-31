extends Node3D
class_name Weapon


var player: Player


func initialize(p: Player) -> void:
	player = p


func uninitialize() -> void:
	pass


func trigger() -> void:
	pass


func release() -> void:
	pass
