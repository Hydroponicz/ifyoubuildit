class_name PlayerBrain
extends Node
## The player's "brain": turns keyboard/mouse into intent for the HumanoidBody.
## Disabled while the bird's-eye camera owns WASD and the mouse.

@export var mouse_sensitivity: float = 0.0025

var controls_enabled: bool = true:
	set(value):
		controls_enabled = value
		if not value and _body != null:
			_body.move_intent = Vector3.ZERO
			_body.sprint_intent = false

@onready var _body: HumanoidBody = get_parent() as HumanoidBody


func _unhandled_input(event: InputEvent) -> void:
	if not controls_enabled:
		return
	var motion := event as InputEventMouseMotion
	if motion != null and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_body.look(-motion.relative.x * mouse_sensitivity, -motion.relative.y * mouse_sensitivity)


func _physics_process(_delta: float) -> void:
	if not controls_enabled:
		return
	var input: Vector2 = Input.get_vector(
		InputActions.MOVE_LEFT, InputActions.MOVE_RIGHT,
		InputActions.MOVE_FORWARD, InputActions.MOVE_BACK)
	var basis: Basis = _body.global_basis
	_body.move_intent = (basis.x * input.x + basis.z * input.y).normalized() * input.length()
	_body.sprint_intent = Input.is_action_pressed(InputActions.SPRINT)
	if Input.is_action_just_pressed(InputActions.JUMP):
		_body.jump_intent = true
