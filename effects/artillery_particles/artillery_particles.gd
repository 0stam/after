extends Node3D
class_name ArtilleryParticles


const DAMAGE = 100.0

var speed: float = 10
var hit_range: float = 30

var target: Vector3  # Should be set when spawned

@onready var player: Player = References.player


func _process(delta: float) -> void:
	global_transform.origin.y -= speed * delta
	
	if global_transform.origin.distance_to(target) < 0.5:  # When the target is reached
		set_process(false)
		
		# Damage equals 100% if player is in 50% of the hit range
		# Than it scales: 100%-0% damage ~ 50%-100% range
		var distance: float = global_transform.origin.distance_to(player.global_transform.origin)
		distance = (distance - (hit_range / 2)) / (hit_range / 2)
		distance = 1 - clampf(distance, 0, 1)
		
		player.take_damage(DAMAGE * distance)
		
		Signals.artillery_hit.emit(Vector2(global_transform.origin.x, global_transform.origin.z))
		queue_free()
