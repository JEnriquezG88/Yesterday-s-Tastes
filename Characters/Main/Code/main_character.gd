extends CharacterBody3D
class_name CharacterController

@onready var animation_tree: AnimationTree = $AnimationTree

enum STATES {
	NONE,
	MOVEMENT,
	JUMP,
	DASH,
	MAGIC,
	CINEMATIC,
	DAMAGE,
	WAITING,
}

var current_state : STATES = STATES.NONE


@onready var cinematics_manager: CinematicsManager = $Code/CinematicsManager
@onready var list: IngredientsList = $UI/List

func return_to_normal_state() -> void:
	pass

@onready var fade: FadeManager = $UI/Fade
func _ready() -> void:
	fade.visible = true
	GlobalSignals.first_scenario_loaded.connect(_on_first_scenario_loaded)

func _on_first_scenario_loaded() -> void:
	GlobalSignals.first_scenario_loaded.disconnect(_on_first_scenario_loaded)
	await fade._fade_in()
	current_state = CharacterController.STATES.WAITING
	await get_tree().create_timer(0.5).timeout
	list.start_list_menu()
