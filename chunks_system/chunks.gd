extends Node3D


var chunks: Dictionary = {}  # Node references: {"x_coorinate,y_coordinate": node_ref}

# Map state stored for save system and chunk loading/unloading
# {"x,y": {"id":"some_id", "type": "village/hostile", "collectibles": [name1, name2, ...]}, ...}
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
	if randi() % 2:
		type = "hostile"
	
	# Create and register a new chunk
	var id: String = PlotTracker.get_option(chunk_data[type])
	var new_chunk: Node3D = create_chunk_from_path(chunk_data[type][id]["path"], pos)
	map_state[chunk_name] = {"id": id, "type": type, "destroyed_coll": []}
	
	if type == "village":
		for collectible in new_chunk.get_node("Collectibles").get_children():
			collectible.chunk_name = chunk_name
			collectible.destroyed.connect(_collectible_destroyed)


# Create a chunk based on a previously saved data
func load_chunk(pos: Vector2i) -> void:
	var chunk_name: String = str(pos.x) + "," + str(pos.y)
	var type: String = map_state[chunk_name]["type"]
	var id: String = map_state[chunk_name]["id"]
	var new_chunk: Node3D = create_chunk_from_path(chunk_data[type][id]["path"], pos)
	
	for collectible_name in map_state[chunk_name]["destroyed_coll"]:
		new_chunk.get_node("Collectibles/" + collectible_name).queue_free()


func _collectible_destroyed(coll_name: String, chunk_name: String) -> void:
	map_state[chunk_name]["destroyed_coll"].append(coll_name)


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


func _ready() -> void:
	_on_player_position_check_timer_timeout()
