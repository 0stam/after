extends Decal


@onready var hurt_box: Area3D = $HurtBox
@onready var despawn_timer: Timer = $DespawnTimer


func _on_hurt_box_area_entered(area: EnemyHitbox) -> void:
	if area != null:
		area.take_damage(50)


func _on_charge_timer_timeout() -> void:
	hurt_box.monitoring = true
	despawn_timer.start()


func _on_despawn_timer_timeout() -> void:
	queue_free()

