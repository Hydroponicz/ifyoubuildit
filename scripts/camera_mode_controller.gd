class_name CameraModeController
extends Node
## Cycles first person -> third person -> bird's-eye with one key (V).

enum Mode { FIRST_PERSON, THIRD_PERSON, BIRDS_EYE }

signal mode_changed(mode: Mode)

@export var player: HumanoidBody
@export var brain: PlayerBrain
@export var first_person_camera: Camera3D
@export var third_person_camera: Camera3D
@export var overhead: OverheadCamera
## Hidden in first person so the player doesn't see the inside of their own head.
@export var player_mesh: GeometryInstance3D

var mode: Mode = Mode.FIRST_PERSON


func _ready() -> void:
	_apply_mode()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.CYCLE_CAMERA):
		mode = ((mode + 1) % Mode.size()) as Mode
		_apply_mode()
	elif event.is_action_pressed(InputActions.RELEASE_MOUSE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		if mode != Mode.BIRDS_EYE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _apply_mode() -> void:
	var birds_eye: bool = mode == Mode.BIRDS_EYE
	first_person_camera.current = mode == Mode.FIRST_PERSON
	third_person_camera.current = mode == Mode.THIRD_PERSON
	overhead.activate(birds_eye)
	brain.controls_enabled = not birds_eye
	player_mesh.visible = mode != Mode.FIRST_PERSON
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if birds_eye else Input.MOUSE_MODE_CAPTURED
	mode_changed.emit(mode)
