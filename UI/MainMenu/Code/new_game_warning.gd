extends VBoxContainer
class_name NewGameWarning

@export var previous_menu : VBoxContainer = null

@onready var return_button: Button = $VBoxContainer/HBoxContainer/ReturnButton
@onready var accept_bton: Button = $VBoxContainer/HBoxContainer/AcceptButton


func _ready() -> void:
	visible = false


func start_menu() -> void:
	visible = true
	return_button.grab_focus()
	_init_button_signals()

func _init_button_signals() -> void:
	accept_bton.button_up.connect(_on_accept_bton_up)
	return_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	
	return_button.button_up.disconnect(_on_exit_button_up)

func _on_exit_button_up() -> void:
	_finish_button_signals()
	visible = false
	if previous_menu:
		previous_menu.start_menu()

func _on_accept_bton_up() -> void:
	var save_directory_path : String = "user://save"
	
	var dir:= DirAccess.open(save_directory_path)
	
	for folder in dir.get_directories():
		var folder_path : String = save_directory_path + "/" + folder
		var folder_dir : = DirAccess.open(folder_path)
		for file in folder_dir.get_files():
			folder_dir.remove(file)
		dir.remove_absolute(folder_path)
	DirAccess.remove_absolute(save_directory_path)
	
	previous_menu._on_start_button_up()
