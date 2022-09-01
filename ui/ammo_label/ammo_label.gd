extends Label

func _process(delta: float) -> void:
	text = "Ammo: " + str(References.player.ammo)
