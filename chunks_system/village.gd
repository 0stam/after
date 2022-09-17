extends Area3D

@export var artillery_targets: Array[NodePath]


func _on_village_body_entered(body: Node3D) -> void:
	# TODO: add countdown UI
	print("Soon")
	await get_tree().create_timer(randi_range(2, 3))
	for path in artillery_targets:
		get_node(path).start()
		print("Didn't crash")
