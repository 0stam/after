extends Node


var chunk_size: int = 250


func _ready() -> void:
	Engine.physics_ticks_per_second = round(DisplayServer.screen_get_refresh_rate(0))
	print(DisplayServer.screen_get_refresh_rate(0))
