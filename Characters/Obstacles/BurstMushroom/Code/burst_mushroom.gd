extends ObstacleCharacters
class_name BurstMushroom

enum MUSHROOM_TYPES {
	NORMAL,
	FIRE,
	ICE,
	STRONG
}
@export var mushroom_type: MUSHROOM_TYPES = MUSHROOM_TYPES.NORMAL

@export var enable_collisions : bool = true
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

enum STATES {
	IDLE,
	ATTAKING,
	CULL_DOWN,
	DAMAGE
}
var current_state : STATES = STATES.IDLE

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ice: MeshInstance3D = $Ice
@onready var burst_mushroom: MeshInstance3D = $BurstMushroomArmature/Skeleton3D/BurstMushroom
@onready var culldown_timer: Timer = $CulldownTimer
var burst_mushroom_material : StandardMaterial3D

@onready var detect_character: Area3D = $Systems/Areas/DetectCharacter
@onready var fire_sfx: AudioStreamPlayer3D = $FireSFX


func _ready() -> void:
	if not enable_collisions:
		collision_shape_3d.disabled = true
	burst_mushroom_material = burst_mushroom.get_active_material(0).duplicate()
	burst_mushroom.set_surface_override_material(0, burst_mushroom_material)
	burst_mushroom_material.emission_enabled = false
	burst_mushroom_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	burst_mushroom_material.albedo_texture = burst_mushroom_material.emission_texture
	
	match mushroom_type:
		MUSHROOM_TYPES.NORMAL:
			burst_mushroom_material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
		MUSHROOM_TYPES.FIRE:
			burst_mushroom_material.albedo_color = Color(1.0, 0.6, 0.6, 1.0)
		MUSHROOM_TYPES.ICE:
			burst_mushroom_material.albedo_color = Color(0.6, 0.6, 1.0, 1.0)
		MUSHROOM_TYPES.STRONG:
			burst_mushroom_material.albedo_color = Color(0.6, 0.6, 0.6, 1.0)
	
	detect_character.body_entered.connect(_on_detect_character_body_entered)
	detect_character.body_exited.connect(_on_detect_character_body_exited)

var consecutive_magic_shots : int = 0

func _on_magic_shot(magic_type: MagicSystem.MAGIC_TYPES) -> void:
	if current_state != STATES.DAMAGE:
		consecutive_magic_shots = consecutive_magic_shots + 1
		if consecutive_magic_shots == 2:
			GlobalSignals.shot_magic.disconnect(_on_magic_shot)
			detect_character.body_entered.disconnect(_on_detect_character_body_entered)
			detect_character.body_exited.disconnect(_on_detect_character_body_exited)
			if not culldown_timer.is_stopped():
				culldown_timer.stop()
			is_character_in_area = false
			consecutive_magic_shots = 0
			match magic_type:
				MagicSystem.MAGIC_TYPES.ICE:
					match mushroom_type:
						MUSHROOM_TYPES.NORMAL:
							ice.visible = true
							animation_tree.set("parameters/Damages/DamageTypes/transition_request", "ice")
							animation_tree.set("parameters/GeneralStates/transition_request", "damage")
							current_state = STATES.DAMAGE
							hit_1.emitting = true
							hit_2.emitting = true
							hit_3.emitting = true
							audio.stop()
							audio.stream = HARD_IMPACT
							audio.play()
						MUSHROOM_TYPES.ICE:
							pass
						MUSHROOM_TYPES.FIRE:
							mushroom_type = MUSHROOM_TYPES.NORMAL
							burst_mushroom_material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
						MUSHROOM_TYPES.STRONG:
							pass
				MagicSystem.MAGIC_TYPES.FIRE:
					match mushroom_type:
						MUSHROOM_TYPES.NORMAL:
							fire_particles.emitting = true
							_fire_sound()
							burst_mushroom_material.albedo_color = Color(0.245, 0.245, 0.245, 1.0)
							animation_tree.set("parameters/Damages/DamageTypes/transition_request", "back_damage")
							animation_tree.set("parameters/GeneralStates/transition_request", "damage")
							current_state = STATES.DAMAGE
							hit_1.emitting = true
							hit_2.emitting = true
							hit_3.emitting = true
							audio.stop()
							audio.stream = HARD_IMPACT
							audio.play()
						MUSHROOM_TYPES.ICE:
							fire_particles.emitting = true
							mushroom_type = MUSHROOM_TYPES.NORMAL
							burst_mushroom_material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
						MUSHROOM_TYPES.FIRE:
							pass
						MUSHROOM_TYPES.STRONG:
							pass
				MagicSystem.MAGIC_TYPES.BROKE:
					match mushroom_type:
						MUSHROOM_TYPES.NORMAL:
							animation_tree.set("parameters/Damages/DamageTypes/transition_request", "up_damage")
							animation_tree.set("parameters/GeneralStates/transition_request", "damage")
							current_state = STATES.DAMAGE
							hit_1.emitting = true
							hit_2.emitting = true
							hit_3.emitting = true
							audio.stop()
							audio.stream = HARD_IMPACT
							audio.play()
						MUSHROOM_TYPES.ICE:
							pass
						MUSHROOM_TYPES.FIRE:
							pass
						MUSHROOM_TYPES.STRONG:
							mushroom_type = MUSHROOM_TYPES.NORMAL
							burst_mushroom_material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)

func _fire_sound() -> void:
	fire_sfx.volume_db = -5.0
	fire_sfx.play()
	await get_tree().create_timer(0.5).timeout
	
	var tween : Tween = create_tween()
	tween.tween_property(fire_sfx, "volume_db", -80.0, 2.0)
	await tween.finished
	
	fire_sfx.stop()

var is_character_in_area : bool = false
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

@onready var hit_1: GPUParticles3D = $Hit1
@onready var hit_2: GPUParticles3D = $Hit2
@onready var hit_3: GPUParticles3D = $Hit3

@onready var fire_particles: GPUParticles3D = $FireParticles

func _on_detect_character_body_entered(_body: Node3D) -> void:
	is_character_in_area = true
	GlobalSignals.is_stamp_sound.emit(true)
	GlobalSignals.shot_magic.connect(_on_magic_shot)
	if current_state == STATES.IDLE:
		current_state = STATES.ATTAKING
		animation_tree.set("parameters/Normals/Idles/transition_request", "culldown")
		animation_tree.set("parameters/Normals/BurstOneShot/request", 1)
		audio.stop()
		audio.pitch_scale = 0.8
		audio.stream = CHARGE_MAGIC
		audio.play()
		await animation_tree.animation_finished
		if current_state == STATES.ATTAKING:
			current_state = STATES.CULL_DOWN
			GlobalSignals.camera_shake.emit(0.2, 0.1)
			gpu_particles_3d.emitting = true
			hit_1.emitting = true
			hit_2.emitting = true
			hit_3.emitting = true
			culldown_timer.start()
			audio.pitch_scale = 1.0
			audio.stop()
			audio.stream = BIG_BURST
			audio.play()
			spores_collision.disabled = false
			await get_tree().create_timer(0.2).timeout
			spores_collision.disabled = true

@onready var spores_collision: CollisionShape3D = $Systems/Areas/SporesArea/CollisionShape3D


@onready var audio: AudioStreamPlayer3D = $Audio

const BIG_BURST = preload("uid://b32t1vgbngpwm")

const CHARGE_MAGIC = preload("uid://c5l7tyvpds6c1")
const HARD_IMPACT = preload("uid://twx041d7b7w6")


func _on_detect_character_body_exited(_body: Node3D) -> void:
	is_character_in_area = false
	GlobalSignals.is_stamp_sound.emit(false)
	consecutive_magic_shots = 0
	GlobalSignals.shot_magic.disconnect(_on_magic_shot)


func _on_culldown_timer_timeout() -> void:
	current_state = STATES.IDLE
	if is_character_in_area:
		_on_detect_character_body_entered(self)
