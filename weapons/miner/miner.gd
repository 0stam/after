extends Weapon


var mine_scene: PackedScene = preload("res://weapons/miner/mine.tscn")

@onready var ray_cast: RayCast3D = $RayCast3D
@onready var cooldown_timer: Timer = $CooldownTimer


func trigger() -> void:
	if not cooldown_timer.is_stopped():
		return
	
	if not ray_cast.is_colliding():
		return
	
	var mine: Decal = mine_scene.instantiate()
	References.spawns.add_child(mine)
	mine.global_transform.origin = ray_cast.get_collision_point()
	
	cooldown_timer.start()
	
