extends Node
class_name InputAndBuffer

@onready var character_controller: CharacterController = $"../.."
@onready var movement: Movement = $"../Movement"


enum ACTIONS {
	NONE,
	JUMP,
	DASH,
	MAGIC
}
var current_pending_action : ACTIONS = ACTIONS.NONE

var buffer_timer : Timer = Timer.new()

func _ready() -> void:
	_initialize()

func _initialize() -> void:
	buffer_timer.one_shot = true
	buffer_timer.wait_time = 0.2
	buffer_timer.name = "BufferTimer"
	buffer_timer.timeout.connect(_on_buffer_timer_timeout)
	add_child(buffer_timer)

func _input(event: InputEvent) -> void:
	var current_input_action : ACTIONS = ACTIONS.NONE
	
	if Input.is_action_just_pressed("jump"):
		current_input_action = ACTIONS.JUMP
	if Input.is_action_just_pressed("dash"):
		print("dash button")
		current_input_action = ACTIONS.DASH

	if current_input_action != ACTIONS.NONE:
		process_pending_actions(current_input_action)

func process_pending_actions(current_input_action: ACTIONS) -> void:
	var update_buffer : bool = false
	match current_input_action:
		ACTIONS.JUMP:
			if not movement.try_jump():
				update_buffer = true
		ACTIONS.DASH:
			if not movement.try_dash():
				update_buffer = true
	
	if update_buffer:
		current_pending_action = current_input_action
		print("UPDATE ACTION")
		if not buffer_timer.is_stopped(): buffer_timer.stop()
		buffer_timer.start()
	elif current_pending_action == ACTIONS.NONE:
		print("NONE")
		current_pending_action = ACTIONS.NONE
		if not buffer_timer.is_stopped():
			buffer_timer.stop()

func clear_current_action() -> void:
	current_pending_action = ACTIONS.NONE

func _on_buffer_timer_timeout() -> void:
	print("update_buffer clean")
	clear_current_action()
