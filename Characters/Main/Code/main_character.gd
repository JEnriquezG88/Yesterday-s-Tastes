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

func return_to_normal_state() -> void:
	pass

func _ready() -> void:
	fade.visible = true
	GlobalSignals.first_scenario_loaded.connect(_on_first_scenario_loaded)

@onready var fade: FadeManager = $UI/Fade
func _on_first_scenario_loaded() -> void:
	GlobalSignals.first_scenario_loaded.disconnect(_on_first_scenario_loaded)
	await fade._fade_in()
	current_state = STATES.MOVEMENT
