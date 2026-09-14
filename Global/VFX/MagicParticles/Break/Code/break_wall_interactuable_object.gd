extends InteractuableObject
class_name BreakWallInteractuableObject

@onready var break_wall: Node3D = $break_wall
@onready var break_particles: GPUParticles3D = $BreakParticles

const BIG_BURST = preload("uid://dmmj1bx8ntlee")


func _ready() -> void:
	super._ready()
	
func charge_completed() -> void:
	queue_free()

func interact() -> void:
	break_wall.visible = false
	break_particles.emitting = true
	shot_sound(BIG_BURST)
