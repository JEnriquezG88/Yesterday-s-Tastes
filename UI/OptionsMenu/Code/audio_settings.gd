extends VBoxContainer
class_name AudioMenu

@export var previous_menu : VBoxContainer = null

@onready var master_volume_slider: HSlider = $MasterVolume/HSlider
@onready var vfx_volume_slider: HSlider = $VFXVolume/HSlider
@onready var voices_volume_slider: HSlider = $VoicesVolume/HSlider
@onready var music_volume_slider: HSlider = $MusicVolume/HSlider
@onready var return_button: Button = $ReturnButton


func _ready() -> void:
	visible = false


func start_menu() -> void:
	visible = true
	master_volume_slider.grab_focus()
	_init_button_signals()
	_load_values()

func _init_button_signals() -> void:
	master_volume_slider.focus_exited.connect(_on_master_volume_focus_exited)
	vfx_volume_slider.focus_exited.connect(_on_vfx_volume_focus_exited)
	voices_volume_slider.focus_exited.connect(_on_voices_volume_focus_exited)
	music_volume_slider.focus_exited.connect(_on_music_volume_focus_exited)
	return_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	master_volume_slider.focus_exited.disconnect(_on_master_volume_focus_exited)
	vfx_volume_slider.focus_exited.disconnect(_on_vfx_volume_focus_exited)
	voices_volume_slider.focus_exited.disconnect(_on_voices_volume_focus_exited)
	music_volume_slider.focus_exited.disconnect(_on_music_volume_focus_exited)
	return_button.button_up.disconnect(_on_exit_button_up)

func _on_exit_button_up() -> void:
	_finish_button_signals()
	visible = false
	if previous_menu:
		previous_menu.start_menu()

func _load_values() -> void:
	master_volume_slider.value = db_to_linear(GameSettings.config.get_value("audio", "Master")) * 100
	vfx_volume_slider.value = db_to_linear(GameSettings.config.get_value("audio", "VFX")) * 100
	voices_volume_slider.value = db_to_linear(GameSettings.config.get_value("audio", "Voices")) * 100
	music_volume_slider.value = db_to_linear(GameSettings.config.get_value("audio", "Music")) * 100


func _on_master_volume_focus_exited() -> void:
	GameSettings.set_bus_volume("Master", master_volume_slider.value)

func _on_vfx_volume_focus_exited() -> void:
	GameSettings.set_bus_volume("VFX", vfx_volume_slider.value)

func _on_voices_volume_focus_exited() -> void:
	GameSettings.set_bus_volume("Voices", voices_volume_slider.value)

func _on_music_volume_focus_exited() -> void:
	GameSettings.set_bus_volume("Music", music_volume_slider.value)
