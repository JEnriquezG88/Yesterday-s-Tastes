extends Node3D
class_name TemporalPlatform

@export var platform_time : float = 1.0
@export var log : bool = false
var elapsed_time : float = 0.0
var elapsed_time_2 : float = 0.0
@onready var break_particles: GPUParticles3D = $BreakParticles
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
const COLLAPSE_SOUND = preload("uid://bfxgxnm8ub2s2")


@onready var temporal_platform_mesh: Node3D = $TemporalPlatform_001
@onready var temporal_platform_floor: CollisionShape3D = $"TemporalPlatform_001/@StaticBody3D@264856/CollisionShape3D"
@onready var animation_player: AnimationPlayer = $TemporalPlatform_001/TemporalPlatform/AnimationPlayer

@onready var character_detector: Area3D = $CharacterDetector

var _character_touch_the_platform : bool = false
var _character_touch_the_platform_2 : bool = false

func _ready() -> void:
	character_detector.body_entered.connect(_on_character_detector_body_entered)
	set_process(false)

func _process(delta: float) -> void:
	if _character_touch_the_platform_2:
		elapsed_time_2 = elapsed_time_2 + delta
		if log:
			print(elapsed_time_2)

	if _character_touch_the_platform:
		elapsed_time = elapsed_time + delta

		if elapsed_time >= platform_time:
			set_process(false)
			break_particles.emitting = true
			temporal_platform_mesh.visible = false
			temporal_platform_floor.disabled = true

func _on_character_detector_body_entered(_body: Node3D) -> void:
	character_detector.body_entered.disconnect(_on_character_detector_body_entered)
	character_detector.body_exited.connect(_on_character_detector_body_exited)
	animation_player.play("shake_animation")
	audio_stream_player_3d.stream = COLLAPSE_SOUND
	audio_stream_player_3d.play()
	_character_touch_the_platform = true
	_character_touch_the_platform_2 = true
	set_process(true)

func _on_character_detector_body_exited(_body: Node3D) -> void:
	_character_touch_the_platform_2 = false

func reset_platform() -> void:
	scale = Vector3.ZERO
	character_detector.body_entered.connect(_on_character_detector_body_entered)
	character_detector.body_exited.disconnect(_on_character_detector_body_exited)
	animation_player.stop()
	_character_touch_the_platform = false
	elapsed_time = 0.0
	elapsed_time_2 = 0.0
	_character_touch_the_platform = false
	_character_touch_the_platform_2 = false
	temporal_platform_mesh.visible = true
	temporal_platform_floor.disabled = false
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
