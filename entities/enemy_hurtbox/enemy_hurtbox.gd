extends Area3D
class_name EnemyHurtbox

@export var damage: float = 15
@export var knockback: float = 30


func hurt(player: Player):
	player.take_damage(damage)
	var knock_direction: Vector3 = global_transform.origin.direction_to(player.global_transform.origin)
	player.velocity += knock_direction * knockback


func _init() -> void:
	collision_layer = 0
	collision_mask = 16
	monitorable = false
	
	body_entered.connect(_on_enemy_hurtbox_body_entered)


func _on_enemy_hurtbox_body_entered(body: Node3D) -> void:
	if body is Player:
		hurt(body)
