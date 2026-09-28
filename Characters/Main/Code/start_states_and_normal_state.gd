extends Node
class_name StartStatesAndNormalState


@onready var fade: FadeManager = $UI/Fade
func _ready() -> void:
	fade.visible = true
	GlobalSignals.first_scenario_loaded.connect(_on_first_scenario_loaded)

func _on_first_scenario_loaded() -> void:
	GlobalSignals.first_scenario_loaded.disconnect(_on_first_scenario_loaded)
	await fade._fade_in()
	current_state = CharacterController.STATES.MOVEMENT

func _return_to_normal_state() -> void:
	pass
