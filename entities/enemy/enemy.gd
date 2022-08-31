extends CharacterBody3D
class_name Enemy


var max_hp: float = 50
var hp: float = max_hp

var hit_particles_scene: PackedScene = preload("res://effects/hit_particles/hit_particles.tscn")

@onready var player: Player = References.player


func take_damage(val: float) -> void:
	hp -= val
	
	var hit_particles: GPUParticles3D = hit_particles_scene.instantiate()
	get_parent().add_child(hit_particles)
	hit_particles.global_transform.origin = global_transform.origin
	
	
	if hp <= 0:
		queue_free()


func heal(val: float) -> void:
	hp = clamp(hp + val, 0, max_hp)
