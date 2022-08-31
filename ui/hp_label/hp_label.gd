extends Label


func _process(delta: float) -> void:
	text = str(round(References.player.hp))
