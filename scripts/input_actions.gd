class_name InputActions
extends RefCounted
## Registers default input actions at runtime, so the game works without
## editing the Input Map in project.godot. Actions already defined in the
## Input Map are left alone, so you can rebind them in Project Settings.

const MOVE_FORWARD: StringName = &"move_forward"
const MOVE_BACK: StringName = &"move_back"
const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"
const JUMP: StringName = &"jump"
const SPRINT: StringName = &"sprint"
const CYCLE_CAMERA: StringName = &"cycle_camera"
const ROTATE_LEFT: StringName = &"camera_rotate_left"
const ROTATE_RIGHT: StringName = &"camera_rotate_right"
const RELEASE_MOUSE: StringName = &"release_mouse"


static func ensure_defaults() -> void:
	_add_keys(MOVE_FORWARD, [KEY_W, KEY_UP])
	_add_keys(MOVE_BACK, [KEY_S, KEY_DOWN])
	_add_keys(MOVE_LEFT, [KEY_A, KEY_LEFT])
	_add_keys(MOVE_RIGHT, [KEY_D, KEY_RIGHT])
	_add_keys(JUMP, [KEY_SPACE])
	_add_keys(SPRINT, [KEY_SHIFT])
	_add_keys(CYCLE_CAMERA, [KEY_V])
	_add_keys(ROTATE_LEFT, [KEY_Q])
	_add_keys(ROTATE_RIGHT, [KEY_E])
	_add_keys(RELEASE_MOUSE, [KEY_ESCAPE])


static func _add_keys(action: StringName, keys: Array[Key]) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	for key: Key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action, event)
