extends Weapon

@onready var ray_cast: RayCast3D = $RayCast3D
@onready var cast_time: Timer = $CastTime
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func uninitialize() -> void:
	player.speed_multiplier = 1


func trigger() -> void:
	if not cast_time.is_stopped():
		return
	
	var target: Node3D = ray_cast.get_collider()
	if target != null and target.has_method("take_damage"):
		target.take_damage(30)
	
	player.speed_multiplier = 0
	animation_player.play("hit")
	cast_time.start()


func _on_cast_time_timeout() -> void:
	player.speed_multiplier = 1
