extends Node3D
class_name LevelSections

var sections: Array[Node3D] = []

func _ready() -> void:
	sections.resize(10)

func load_section(path: String, index: int) -> void:
	var array_index = index - 1
	
	var scene : PackedScene = await _load_scene_async(path)
	
	var section : Node3D = scene.instantiate()
	
	sections[array_index] = section
	
	add_child(section)

func unload_section(index: int) -> void:
	var array_index = index - 1
	
	sections[array_index].queue_free()
	sections[array_index] = null

func _load_scene_async(path: String) -> PackedScene:
	var error := ResourceLoader.load_threaded_request(path)
	
	while true:
		var status := ResourceLoader.load_threaded_get_status(path)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame
			ResourceLoader.THREAD_LOAD_LOADED:
				return ResourceLoader.load_threaded_get(path) as PackedScene
	return null
