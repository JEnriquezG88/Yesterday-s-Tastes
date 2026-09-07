extends ColorRect
class_name FadeManager

@export var ready_fade_in: bool = true

func _ready() -> void:
	if ready_fade_in:
		visible = true
		_fade_in()
	else:
		visible = false

func _fade_in(time: float = 0.5) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, time)
	await tween.finished
	await get_tree().process_frame

func _fade_out(time: float = 0.5) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, time)
	await tween.finished
	await get_tree().process_frame
