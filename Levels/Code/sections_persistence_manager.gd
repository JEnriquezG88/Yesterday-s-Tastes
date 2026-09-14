extends Node3D
class_name SectionsPersistenceManager


@onready var section_data: SectionData = $SectionData

func get_save_folder() -> String:
	return "user://save/level_" + str(section_data.level)

func get_save_data_path() -> String:
	return get_save_folder() + "/section_" + str(section_data.section) + ".dat"

var interactions_data : Dictionary = { }

@export var interactions : Array[InteractionSystem]

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(get_save_folder())
	
	var interaction_index : int = 0
	for interaction in interactions:
		interaction.finish_signal.connect(_finish_interaction.bind(interaction_index))
		interactions_data[interaction_index] = false
		interaction_index = interaction_index + 1
	_load_data()
	_apply_load_data()

func _apply_load_data() -> void:
	for interaction_index in interactions_data:
		if interactions_data[interaction_index]:
			interactions[interaction_index].charge_completed()

func _finish_interaction(interaction_index: int) -> void:
	interactions_data[interaction_index] = true
	_save_data()

func _save_data() -> void:
	var save_file = FileAccess.open(get_save_data_path(), FileAccess.WRITE)
	
	save_file.store_var(interactions_data)
	save_file = null

func _load_data() -> void:
	if FileAccess.file_exists(get_save_data_path()):
		var save_file = FileAccess.open(get_save_data_path(), FileAccess.READ)
		
		interactions_data = save_file.get_var()
		save_file = null
	else:
		_save_data()
