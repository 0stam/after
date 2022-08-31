extends Area3D
class_name EnemyHitbox

signal damage_taken(val: float)


func take_damage(val: float) -> void:  # Called by a weapon
	damage_taken.emit(val)


func _init() -> void:
	collision_layer = 32
	collision_mask = 0
	monitoring = false
