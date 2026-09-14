extends InteractuableObject
class_name IceInteractuableObject

func _ready() -> void:
	super._ready()
	scale = Vector3.ZERO

func interact() -> void:
	var tween : Tween = create_tween()
	
	tween.tween_property(self, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func charge_completed() -> void:
	scale = Vector3.ONE
