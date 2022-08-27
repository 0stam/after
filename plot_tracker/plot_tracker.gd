extends Node


var flags: Dictionary = {
	"test_chunk_enabled": true
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
