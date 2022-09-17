extends Node3D
class_name ArtilleryParticles


const DAMAGE = 100.0

var speed: float = 10
var hit_range: float = 30

var despawn_queued: bool = false

var target: Vector3  # Should be set when spawned

@onready var player: Player = References.player


func _process(delta: float) -> void:
	if despawn_queued:
		return
	
	global_transform.origin.y -= speed * delta
	
	if global_transform.origin.distance_to(target) < 0.5 and not despawn_queued:
		set_process(false)
		despawn_queued = true
		
		var distance: float = global_transform.origin.distance_to(player.global_transform.origin)
		distance = (distance - (hit_range / 2)) / (hit_range / 2)
		distance = 1 - clampf(distance, 0, 1)
		
		player.take_damage(DAMAGE * distance)
		
		Signals.artillery_hit.emit(Vector2(global_transform.origin.x, global_transform.origin.z))
		queue_free()
