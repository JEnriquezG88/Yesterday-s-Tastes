extends Node
class_name CurrentGamePersistenceCode

var current_game_data : Dictionary[String, bool] = {
	"KornObtained": false,
	"CheeseObtained": false,
	"CoffeObtained": false,
	"movement_tutorial": false,
	"jump_tutorial": false,
	"dash_tutorial": false,
	"combat_tutorial": false,
}

func get_save_folder() -> String:
	return "user://save/level_00"

func get_save_data_path() -> String:
	return get_save_folder() + "/section_lobby.dat"


func _ready() -> void:
	_clean_data()
	_load_data()
	_apply_load_data()

func _clean_data() -> void:
	current_game_data["KornObtained"] = false
	current_game_data["CheeseObtained"] = false
	current_game_data["CoffeObtained"] = false
	current_game_data["movement_tutorial"] = false
	current_game_data["jump_tutorial"] = false
	current_game_data["dash_tutorial"] = false
	current_game_data["combat_tutorial"] = false

func _apply_load_data() -> void:
	pass

func _save_data() -> void:
	print("_save_data")
	if not DirAccess.dir_exists_absolute(get_save_folder()):
		_load_data()
	var save_file = FileAccess.open(get_save_data_path(), FileAccess.WRITE)
	
	save_file.store_var(current_game_data)
	save_file = null

func _load_data() -> void:
	DirAccess.make_dir_recursive_absolute(get_save_folder())
	if FileAccess.file_exists(get_save_data_path()):
		var save_file = FileAccess.open(get_save_data_path(), FileAccess.READ)
		
		current_game_data = save_file.get_var()
		save_file = null
	else:
		_save_data()
