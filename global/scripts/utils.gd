extends Node
class_name Utils


static func parse_json(file_name: String) -> Dictionary:
	var file: File = File.new()
	file.open(file_name, File.READ)
	
	var json: JSON = JSON.new()
	json.parse(file.get_as_text())
	
	file.close()
	return json.get_data()
