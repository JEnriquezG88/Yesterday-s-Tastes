extends Control
class_name IngredientsList

@export var character_controller : CharacterController
var active: bool = false

const CLOSE_LETTER = preload("uid://djbodsclotuxu")
const OPEN_LETTER = preload("uid://4xohg3rxkmqy")
@onready var audio: AudioStreamPlayer = $Audio


@onready var check_01: TextureRect = $CenterContainer/Check01
@onready var check_02: TextureRect = $CenterContainer/Check02
@onready var check_03: TextureRect = $CenterContainer/Check03

@onready var tutoriales: Tutorials = $"../Tutoriales"

func _ready() -> void:
	visible = false
	

func _input(event: InputEvent) -> void:
	if not character_controller: return
	
	if active and event.is_action_released("ui_cancel"):
		start_list_menu()
	if event.is_action_released("select") or (active and event.is_action_released("broke_magic")):
		start_list_menu()

func start_list_menu() -> void:
	if tutoriales.is_in_tutorial: return
	if active:
		if CurrentGamePersistence.current_game_data["CoffeObtained"] and CurrentGamePersistence.current_game_data["CheeseObtained"] and CurrentGamePersistence.current_game_data["KornObtained"]:
			GlobalSignals.open_door.emit()
		active = false
		visible = false
		audio.stop()
		audio.stream = CLOSE_LETTER
		audio.play()
		if not CurrentGamePersistence.current_game_data["movement_tutorial"]:
			GlobalSignals.shot_tutorial.emit(Tutorials.TUTORIALS.MOVEMENT)
		else:
			GlobalSignals.main_character_resume.emit()
	else:
		if character_controller.current_state == CharacterController.STATES.CINEMATIC or character_controller.current_state == CharacterController.STATES.MOVEMENT or character_controller.current_state == CharacterController.STATES.WAITING and character_controller.is_on_floor():
			check_01.visible = CurrentGamePersistence.current_game_data["KornObtained"]
			check_02.visible = CurrentGamePersistence.current_game_data["CheeseObtained"]
			check_03.visible = CurrentGamePersistence.current_game_data["CoffeObtained"]
			active = true
			visible = true
			audio.stop()
			audio.stream = OPEN_LETTER
			audio.play()
			GlobalSignals.main_character_wait.emit()
		else:
			pass
