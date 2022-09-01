extends ShapeCast3D
class_name EnemySpawner

const HEIGHT = 4
const DISTANCE = 60

@onready var player: Player = References.player


func spawn(enemy_scene: PackedScene) -> void:
	# Find empty space
	while true:
		var new_position: Vector2 = Vector2.UP
		new_position = new_position.rotated(randf_range(0, TAU))
		new_position *= DISTANCE
		
		transform.origin.x = new_position.x + player.global_transform.origin.x
		transform.origin.z = new_position.y + player.global_transform.origin.z
		
		force_shapecast_update()
		if not is_colliding():
			break
	
	# Spawn an enemy
	var enemy: Enemy = enemy_scene.instantiate()
	References.spawns.add_child(enemy)
	enemy.global_transform.origin = global_transform.origin


func _ready() -> void:
	transform.origin.y = HEIGHT
