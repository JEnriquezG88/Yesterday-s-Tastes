extends VBoxContainer
class_name LenguageMenu

@export var previous_menu : VBoxContainer = null

@onready var lenguages: OptionButton = $Lenguages
@onready var return_button: Button = $ReturnButton


func _ready() -> void:
	visible = false


func start_menu() -> void:
	visible = true
	lenguages.grab_focus()
	_init_button_signals()
	_load_values()

func _init_button_signals() -> void:
	lenguages.item_selected.connect(_on_item_selected)
	return_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	lenguages.item_selected.disconnect(_on_item_selected)
	return_button.button_up.disconnect(_on_exit_button_up)

func _on_exit_button_up() -> void:
	_finish_button_signals()
	visible = false
	if previous_menu:
		previous_menu.start_menu()

func _load_values() -> void:
	match TranslationServer.get_locale():
		"es":
			lenguages.selected = 0
		"en":
			lenguages.selected = 1

func _on_item_selected(index: int) -> void:
	match index:
		0:
			GameSettings.set_lenguage("es")
		1:
			GameSettings.set_lenguage("en")
