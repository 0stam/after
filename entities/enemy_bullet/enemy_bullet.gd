extends Area3D


var speed: float = 6
var direction: Vector3  # Should be set by a shooter

@onready var player: Player = References.player


func _physics_process(delta: float) -> void:
	transform.origin += direction * speed * delta


func _on_area_3d_body_entered(body: Node3D) -> void:  # On collision with world
	queue_free()


func _on_death_timer_timeout() -> void:
	queue_free()
