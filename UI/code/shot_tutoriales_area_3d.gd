extends Area3D
class_name ShotTutorialsArea


@export var tutorial : Tutorials.TUTORIALS

func _ready() -> void:
	match tutorial:
		Tutorials.TUTORIALS.JUMP:
			if CurrentGamePersistence.current_game_data["jump_tutorial"]:
				queue_free()
		Tutorials.TUTORIALS.DASH:
			if CurrentGamePersistence.current_game_data["dash_tutorial"]:
				queue_free()
		Tutorials.TUTORIALS.ATTACK:
			if CurrentGamePersistence.current_game_data["combat_tutorial"]:
				queue_free()
	body_entered.connect(_body_entered)

func _body_entered(_body: Node3D) -> void:
	GlobalSignals.shot_tutorial.emit(tutorial)
	GlobalSignals.main_character_wait.emit()
	queue_free()
