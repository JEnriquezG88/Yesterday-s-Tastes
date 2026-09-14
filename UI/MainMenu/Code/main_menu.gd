extends VBoxContainer
class_name MainMenu

@onready var buttons_container: ButtonsContainer = $ButtonsContainer

@onready var new_game_warning: NewGameWarning = $"../NewGameWarning"

@onready var fade_manager: FadeManager = $"../../../FadeManager"

func _ready() -> void:
	if DirAccess.dir_exists_absolute("user://save"):
		if buttons_container.current_first_element == start_button:
			buttons_container.change_first_element(continue_button)
		continue_button.visible = true
	else:
		if buttons_container.current_first_element == continue_button:
			buttons_container.change_first_element(start_button)
		continue_button.visible = false
	start_menu()

@onready var start_button: Button = $ButtonsContainer/StartButton
@onready var continue_button: Button = $ButtonsContainer/ContinueButton
@onready var options_button: Button = $ButtonsContainer/OptionsButton
@onready var credits_button: Button = $ButtonsContainer/CreditsButton
@onready var exit_button: Button = $ButtonsContainer/ExitButton


@onready var options_menu: OptionsMenuManager = $"../../OptionsMenu"



func start_menu() -> void:
	visible = true
	_init_button_signals()
	buttons_container.first_element_focus()

func _init_button_signals() -> void:
	start_button.button_up.connect(_on_start_button_up)
	continue_button.button_up.connect(_on_continue_button_up)
	options_button.button_up.connect(_on_options_button_up)
	credits_button.button_up.connect(_on_credits_button_up)
	exit_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	start_button.button_up.disconnect(_on_start_button_up)
	continue_button.button_up.disconnect(_on_continue_button_up)
	options_button.button_up.disconnect(_on_options_button_up)
	credits_button.button_up.disconnect(_on_credits_button_up)
	exit_button.button_up.disconnect(_on_exit_button_up)

func _on_start_button_up() -> void:
	buttons_container.change_first_element(start_button)
	_finish_button_signals()
	
	if DirAccess.dir_exists_absolute("user://save"):
		_finish_button_signals()
		visible = false
		new_game_warning.start_menu()
	else:
		await fade_manager._fade_out()
		visible = false
		get_tree().change_scene_to_file("uid://ghhahuqhg7k4")

func _on_continue_button_up() -> void:
	buttons_container.change_first_element(continue_button)
	_finish_button_signals()
	await fade_manager._fade_out()
	visible = false
	get_tree().change_scene_to_file("uid://ghhahuqhg7k4")

func _on_options_button_up() -> void:
	buttons_container.change_first_element(options_button)
	_finish_button_signals()
	visible = false
	options_menu.start_menu()

func _on_credits_button_up() -> void:
	buttons_container.change_first_element(credits_button)
	_finish_button_signals()
	visible = false

func _on_exit_button_up() -> void:
	_finish_button_signals()
	await fade_manager._fade_out()
	get_tree().quit()
