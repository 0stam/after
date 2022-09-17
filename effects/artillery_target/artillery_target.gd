extends Position3D
class_name ArtilleryTarget

var artillery_particles: PackedScene = preload("res://effects/artillery_particles/artillery_particles.tscn")


func start() -> void:
	var particles: Node3D = artillery_particles.instantiate()
	particles.set_process(false)
	References.spawns.add_child(particles)
	
	particles.global_transform.origin = global_transform.origin
	particles.global_transform.origin.y = 100
	particles.target = global_transform.origin
	
	particles.set_process(true)

