extends AudioStreamPlayer
class_name CinematicMusicManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_music() -> void:
	animation_player.play("fullMusic")
