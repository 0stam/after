extends Node


var flags: Dictionary = {
	"test_chunk_enabled": true,
	"noob": true
}


# [[{flag"world_end_reached",type:"equal",val:"true"}, {...}], [...], [...]] means [[cond1 or cond2 or cond3] and [...] and [...]]
func validate_condition(conditions: Array) -> bool:
	for cond_group in conditions:
		var success: bool = false
		
		for cond in cond_group:
			match cond["type"]:
				"equal":
					if flags[cond["flag"]] == cond["val"]:
						success = true
						break
				"smaller":
					if flags[cond["flag"]] < cond["val"]:
						success = true
						break
				"greater":
					if flags[cond["flag"]] > cond["val"]:
						success = true
						break
				_:
					success = true
					break
			
			if not success:
				return false
	
	return true


# Get an id of an option selected from a dictionary
# First, the function takes only the options with valid conditions
# Than it picks one at random. Options with higher weight have a higher chance of being picked
func get_option(dict: Dictionary) -> String:
	var candidates: Array[Array] = []
	var total_weight: int = 0
	
	# Validate conditions
	for id in dict:
		if validate_condition(dict[id]["condition"]):
			candidates.append([dict[id]["weight"], id])
			total_weight += dict[id]["weight"]
	
	# Choose a random option based on weight
	var rand: int = randi_range(1, total_weight)
	for candidate in candidates:
		rand -= candidate[0]
		if rand <= 0:
			return candidate[1]
	
	return ""  # If no matching options were found
