extends CharacterBody3D
class_name CharacterController

@onready var animation_tree: AnimationTree = $AnimationTree

enum STATES {
	NONE,
	MOVEMENT,
	JUMP,
	DASH,
	MAGIC,
	CINEMATIC,
}

var current_state : STATES = STATES.MOVEMENT
