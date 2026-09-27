extends Node3D
class_name LobbyManager

@onready var cheese_completed: MeshInstance3D = $CheeseCompleted
@onready var coffe_completed: MeshInstance3D = $CoffeCompleted
@onready var korn_completed: MeshInstance3D = $KornCompleted


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
		pass
	elif CurrentGamePersistence.current_game_data["CheeseObtained"]:
		coffe_completed.queue_free()
	elif CurrentGamePersistence.current_game_data["KornObtained"]:
		cheese_completed.queue_free()
	else:
		korn_completed.queue_free()
