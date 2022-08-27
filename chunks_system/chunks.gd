extends Node3D


var chunks: Dictionary = {}
var chunk_data: Dictionary = {}
var buildings_data: Dictionary = {}

var chunk_size: int:
	get:
		return Settings.chunk_size

@onready var player: CharacterBody3D = References.player


func get_current_chunk_pos() -> Vector2i:
	var pos: Vector2i = Vector2i(player.position.x, player.position.z)
	
	# Compensate for the (0, 0) chunk being centered
	if pos.x > 0: pos.x += chunk_size / 2
	else: pos.x -= chunk_size / 2
	
	if pos.y > 0: pos.y += chunk_size / 2
	else: pos.y -= chunk_size / 2
	
	return pos / chunk_size


func get_chunk(pos: Vector2i) -> Node3D:
	var chunk_name: String = str(pos.x) + "," + str(pos.y)
	if chunks.has(chunk_name):
		return chunks[chunk_name]
	else:
		return null


func get_candidate(dict: Dictionary) -> String:
	var candidates: Array[Array] = []
	var total_weight: int = 0
	
	for id in dict:
		if PlotTracker.validate_condition(dict[id]["condition"]):
			candidates.append([dict[id]["weight"], id])
			total_weight += dict[id]["weight"]
	
	var rand: int = randi_range(1, total_weight)
	for candidate in candidates:
		rand -= candidate[0]
		if rand <= 0:
			return candidate[1]
	
	return ""

func create_chunk(pos: Vector2i):
	var type: String = "village"
#	if randi() % 2:
#		type = "hostile"
	
	var id: String = get_candidate(chunk_data[type])
	var new_chunk: Node3D = load(chunk_data[type][id]["path"]).instantiate()
	new_chunk.position.x = pos.x * chunk_size
	new_chunk.position.z = pos.y * chunk_size
	
	chunks[str(pos.x) + "," + str(pos.y)] = new_chunk
	add_child(new_chunk)
	
	if type == "village":
		var substructures: Dictionary = {}
		
		for child in new_chunk.get_children(true):
			if str(child.name).begins_with("substructure"):
				var shape: String = str(child.name).split("_")[1]
				if shape in substructures:
					substructures[shape].append(child)
				else:
					substructures[shape] = [child]
		
		for shape in substructures:
			for node in substructures[shape]:
				id = get_candidate(buildings_data[shape])
				print(node, " ", id)
				var new_building: Node3D = load(buildings_data[shape][id]["path"]).instantiate()
				node.add_child(new_building)
#				new_building.global_position = node.global_position
				new_building.transform.origin = Vector3.ZERO
				print(new_building.global_position, " ", new_chunk.global_position)


func parse_json(file_name: String) -> Dictionary:
	var file: File = File.new()
	file.open(file_name, File.READ)
	
	var json: JSON = JSON.new()
	json.parse(file.get_as_text())
	
	file.close()
	return json.get_data()


func _process(delta: float) -> void:
	for x in range(-1, 2):
		for y in range(-1, 2):
			var pos: Vector2i = Vector2i(x, y) + get_current_chunk_pos()
			if not get_chunk(pos):
				create_chunk(pos)


func _init() -> void:
	seed(1)
	chunk_data = parse_json("res://data/chunks.json")
	buildings_data = parse_json("res://data/buildings.json")
