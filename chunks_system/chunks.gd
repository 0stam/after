extends Node3D


var chunks: Dictionary = {}  # Node references: {"x_coorinate,y_coordinate": node_ref}

# Map state stored for save system and chunk loading/unloading
# {"x,y": {"id":"some_id", "type": "village/hostile", "buildings": {"ChildName": {"id": "some_id", "shape": "some_shape"}, ...}}, ...}
# "ChildName" refers to the name of a substructure node the building was attached to 
var map_state: Dictionary = {}

# Loaded json data files
var chunk_data: Dictionary = {}
var buildings_data: Dictionary = {}

var chunk_size: int:
	get:
		return Settings.chunk_size

@onready var player: CharacterBody3D = References.player


# Get a position of the chunk currently occupied by the player
func get_current_chunk_pos() -> Vector2i:
	var pos: Vector2i = Vector2i(player.position.x, player.position.z)
	
	# Compensate for the (0, 0) chunk being centered, thus reaching only half of the chunk_size in each direction
	if pos.x > 0: pos.x += chunk_size / 2
	else: pos.x -= chunk_size / 2
	
	if pos.y > 0: pos.y += chunk_size / 2
	else: pos.y -= chunk_size / 2
	
	return pos / chunk_size


# Returns a chunk node at a given position or null if chunk doesn't exist
func get_chunk(pos: Vector2i) -> Node3D:
	var chunk_name: String = str(pos.x) + "," + str(pos.y)
	if chunks.has(chunk_name):
		return chunks[chunk_name]
	else:
		return null





# Shared code for creating and setting up a chunk
func create_chunk_from_path(path: String, pos: Vector2i) -> Node3D:
	var new_chunk: Node3D = load(path).instantiate()
	new_chunk.position.x = pos.x * chunk_size
	new_chunk.position.z = pos.y * chunk_size
	
	chunks[str(pos.x) + "," + str(pos.y)] = new_chunk
	add_child(new_chunk)
	
	return new_chunk


# Select a chunk type and create it and its buildings
func create_chunk(pos: Vector2i) -> void:
	var chunk_name: String = str(pos.x) + "," + str(pos.y)
	
	# Randomize the chunk type
	var type: String = "village"
#	if randi() % 2:
#		type = "hostile"
	
	# Create and register a new chunk
	var id: String = PlotTracker.get_option(chunk_data[type])
	var new_chunk: Node3D = create_chunk_from_path(chunk_data[type][id]["path"], pos)
	map_state[chunk_name] = {"id": id, "type": type, "buildings": {}}
	
	# If the chunk is a village, create buildings
	if type == "village":
		var substructures: Dictionary = {}  # {"shape1": [NodeReference1, ...], "shape2": ...}
		
		# Find all substructure meshes
		for child in new_chunk.get_children():
			if str(child.name).begins_with("substructure"):
				var shape: String = str(child.name).split("_")[1]
				if shape in substructures:
					substructures[shape].append(child)
				else:
					substructures[shape] = [child]
		
		# For each substructure found, choose and create an approperiate building
		for shape in substructures:
			for node in substructures[shape]:
				id = PlotTracker.get_option(buildings_data[shape])
				var new_building: Node3D = load(buildings_data[shape][id]["path"]).instantiate()
				map_state[chunk_name]["buildings"][node.name] = {"id": id, "shape": shape}
				node.add_child(new_building)


# Create a chunk based on a previously saved data
func load_chunk(pos: Vector2i) -> void:
	var chunk_name: String = str(pos.x) + "," + str(pos.y)
	var type: String = map_state[chunk_name]["type"]
	var id: String = map_state[chunk_name]["id"]
	var new_chunk: Node3D = create_chunk_from_path(chunk_data[type][id]["path"], pos)
	
	for substructure in map_state[chunk_name]["buildings"]:
		type = map_state[chunk_name]["buildings"][substructure]["shape"]
		id = map_state[chunk_name]["buildings"][substructure]["id"]
		var new_building: Node3D = load(buildings_data[type][id]["path"]).instantiate()
		
		new_chunk.get_node(substructure).add_child(new_building)


# Check if generating new chunks is required
func _on_player_position_check_timer_timeout() -> void:
	for x in range(-1, 2):
		for y in range(-1, 2):
			var pos: Vector2i = Vector2i(x, y) + get_current_chunk_pos()
			if not get_chunk(pos):
				create_chunk(pos)


func _init() -> void:
#	seed(13)
	chunk_data = Utils.parse_json("res://data/chunks.json")
	buildings_data = Utils.parse_json("res://data/buildings.json")


func _ready() -> void:
	_on_player_position_check_timer_timeout()
