extends Node3D
class_name StartCinematic

@onready var kitchen: Node3D = $Kitchen
@onready var room: Node3D = $room


@onready var camera_animation_player: AnimationPlayer = $Camera/AnimationPlayer
@onready var fade_manager: FadeManager = $CanvasLayer/FadeManager
@onready var teleport_fx: ColorRect = $CanvasLayer/TeleportFx

@onready var animation_player: AnimationPlayer = $Character/cinematic_character/AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Character/cinematic_character/CharacterRig/Skeleton3D/AudioStreamPlayer3D
@onready var list_animation_player: AnimationPlayer = $Interactions/AnimationPlayer

func _ready() -> void:
	camera_animation_player.play("StartCameraCinematic/camera_wake_up_animation")
	animation_player.play("StartAnimationsLibrary/wake_up")
	list_animation_player.play("cinematic_list")
	await animation_player.animation_finished
	await fade_manager._fade_out()
	#await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("uid://ghhahuqhg7k4")
