extends Node3D
class_name LobbyManager

@onready var cheese_completed: MeshInstance3D = $CheeseCompleted
@onready var coffe_completed: MeshInstance3D = $CoffeCompleted
@onready var korn_completed: MeshInstance3D = $KornCompleted
@onready var end_cinematic_area: Area3D = $EndCinematicArea



func _ready() -> void:
	#if CurrentGamePersistence.current_game_data["KornObtained"]:
		#cheese_completed.queue_free()
	#elif CurrentGamePersistence.current_game_data["CheeseObtained"]:
		#coffe_completed.queue_free()
	#elif CurrentGamePersistence.current_game_data["CoffeObtained"]:
		#pass
	#else:
		#korn_completed.queue_free()
		
	if CurrentGamePersistence.current_game_data["CoffeObtained"]:
		end_cinematic_area.body_entered.connect(_shot_end_cinematic)
		GlobalSignals.open_door.connect(open_door)
	elif CurrentGamePersistence.current_game_data["CheeseObtained"]:
		end_cinematic_area.queue_free()
		coffe_completed.queue_free()
	elif CurrentGamePersistence.current_game_data["KornObtained"]:
		end_cinematic_area.queue_free()
		cheese_completed.queue_free()
	else:
		end_cinematic_area.queue_free()
		korn_completed.queue_free()

func _shot_end_cinematic(_body: Node3D) -> void:
	GlobalSignals.shot_end_cinematic.emit()
@onready var animation_player: AnimationPlayer = $House_001/AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $House_001/AudioStreamPlayer3D

func open_door() -> void:
	animation_player.play("open_door")
	audio_stream_player_3d.play()
