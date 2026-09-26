extends InteractuableObject
class_name MobileRockInteractuableObject


@onready var mobile_rock: Node3D = $mobile_rock


func _ready() -> void:
	mobile_rock.position.y = - 10
	super._ready()

func interact() -> void:
	super.interact()
	var tween: Tween = create_tween()
	
	var final_position: Vector3 = Vector3.ZERO

	# Sube un poquito más
	tween.tween_property(
		mobile_rock,
		"position",
		final_position + Vector3.UP * 0.15,
		0.25
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Baja un poquito por debajo de la posición final
	tween.tween_property(
		mobile_rock,
		"position",
		final_position - Vector3.UP * 0.05,
		0.15
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	# Finalmente se acomoda en su posición
	tween.tween_property(
		mobile_rock,
		"position",
		final_position,
		0.12
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func charge_completed() -> void:
	super.charge_completed()
