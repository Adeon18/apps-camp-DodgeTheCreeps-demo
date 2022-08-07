extends Node


var score: int = 0
var personal_best: int = 0


func _ready():
	load_data()


func check_personal_best():
	if (score > personal_best):
		personal_best = score


func check_for_saves_directory():
	var directory = Directory.new()
	directory.open("./.")
	if !directory.dir_exists("saves"):
		directory.make_dir("saves")


func save_data():
	check_for_saves_directory()

	var save_file = File.new()
	save_file.open("saves/saves.save", File.WRITE)
	var global_data = save()

	save_file.store_line(to_json(global_data))
	save_file.close()


func load_data():
	check_for_saves_directory()
	var save_file = File.new()

	if not save_file.file_exists("saves/saves.save"):
		return

	save_file.open("saves/saves.save", File.READ)
	while save_file.get_position() < save_file.get_len():
		var global_data = parse_json(save_file.get_line())
		
		for attr in global_data.keys():
			set(attr, global_data[attr])

	save_file.close()


func save():
	var save_dict: Dictionary = {
		"score": score,
		"personal_best": personal_best
	}
	return save_dict


