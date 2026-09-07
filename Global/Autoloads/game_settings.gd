extends Node
class_name GameSettingsScript

const SETTINGS_PATH : String = "user://game_settings/settings.cfg"

var config : ConfigFile = ConfigFile.new()

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute("user://game_settings")
	load_settings()

#region SetSettings

func set_resolution(new_resolution: Vector2i) -> void:
	DisplayServer.window_set_size(new_resolution)
	config.set_value("display", "resolution", new_resolution)
	save_settings()

func set_fullscreen(fullscreen: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	config.set_value("display", "fullscreen", fullscreen)
	save_settings()

func set_max_fps(fps: int) -> void:
	Engine.max_fps = fps
	config.set_value("display", "max_fps", fps)
	save_settings()

func set_bus_volume(bus_name: StringName, volume: float) -> void:
	volume = clampf(volume, 0.0, 100.0)
	
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1: return
	
	var db: = linear_to_db(volume / 100.0)
	
	AudioServer.set_bus_volume_db(bus_index, db)
	
	config.set_value("audio", bus_name, db)
	save_settings()

func set_lenguage(lenguage: String) -> void:
	TranslationServer.set_locale(lenguage)
	config.set_value("lenguage", "locale", lenguage)
	save_settings()

#endregion

func save_settings() -> void:
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	if config.load(SETTINGS_PATH) != OK: 
		save_settings()
	
	#region Graphics
	DisplayServer.window_set_size(config.get_value("display", "resolution", Vector2i(1920, 1080)))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if config.get_value("display", "fullscreen", false) else DisplayServer.WINDOW_MODE_WINDOWED)
	Engine.max_fps = config.get_value("display", "max_fps", 60)
	#endregion
	#region Audio
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), config.get_value("audio", "Master", 0.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("VFX"), config.get_value("audio", "VFX", 0.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voices"), config.get_value("audio", "Voices", 0.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), config.get_value("audio", "Music", 0.0))
	#endregion
	#region Lenguage
	var default_lenguage : String = OS.get_locale_language()
	if default_lenguage != "es" and default_lenguage != "en":
		default_lenguage = "en"
	TranslationServer.set_locale(config.get_value("lenguage", "locale", default_lenguage))
	#endregion
