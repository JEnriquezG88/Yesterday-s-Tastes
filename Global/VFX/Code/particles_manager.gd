extends Node3D
class_name GlobalParticlesManager

func _ready() -> void:
	_create_jump_magic_particles()
	_create_smoke_particles()

#region Magic

const JUMP_MAGIC_FX_PATH : String = "uid://blvr4oigc0f3t"
var jump_magic_fxs : Array[JumpMagicFXManager]

var smoke_particles_manager : SmokeParticlesManager = SmokeParticlesManager.new()

func _create_jump_magic_particles() -> void:
	var jump_magic_fx_scene : PackedScene = load(JUMP_MAGIC_FX_PATH)
	for i in range(5):
		var new_jump_magic_fx : JumpMagicFXManager = jump_magic_fx_scene.instantiate()
		new_jump_magic_fx.name = "JumpMagixFX" + str(i)
		jump_magic_fxs.append(new_jump_magic_fx)
		add_child(new_jump_magic_fx)
	GlobalSignals.shot_jump_magic_particles.connect(_shot_jump_particles_fx)

func _get_jump_magic_available_particles() -> JumpMagicFXManager:
	for jump_magic_fx in jump_magic_fxs:
		if jump_magic_fx.available:
			return jump_magic_fx
	return null

func _shot_jump_particles_fx(position: Vector3) -> void:
	var jump_fx_partile : JumpMagicFXManager = _get_jump_magic_available_particles()
	if not jump_fx_partile: return
	jump_fx_partile.global_position = position
	jump_fx_partile.shot_particles()

func _create_smoke_particles() -> void:
	add_child(smoke_particles_manager)
#endregion
