extends Label


func _process(delta: float) -> void:
	text = "HP: " + str(round(References.player.hp))
