extends Weapon


@onready var ray_cast: RayCast3D = $RayCast3D


func trigger() -> void:
	if player.ammo <= 0:
		return
	player.ammo -= 1
	
	var target: Node3D = ray_cast.get_collider()
	if target != null and target.has_method("take_damage"):
		target.take_damage(999999)
