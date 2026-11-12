class_name OverheadCamera
extends Node3D
## Bird's-eye command/blueprint camera. This node is the focus point on the
## ground; it yaws around Y, and the camera sits back along a fixed pitch.
## While inactive it keeps following `follow_target` so it opens over the player.

@export var follow_target: Node3D
@export var pan_speed: float = 40.0
@export var rotate_speed: float = 1.8
@export var zoom_step: float = 4.0
@export var min_distance: float = 10.0
@export var max_distance: float = 120.0
@export var pitch_deg: float = -55.0

var active: bool = false

var _distance: float = 40.0

@onready var _pitch: Node3D = $Pitch
@onready var camera: Camera3D = $Pitch/Camera3D


func _ready() -> void:
	_pitch.rotation.x = deg_to_rad(pitch_deg)
	_apply_zoom()


func activate(on: bool) -> void:
	active = on
	camera.current = on
	if on and follow_target != null:
		global_position = follow_target.global_position
		rotation.y = follow_target.global_rotation.y


func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	var button := event as InputEventMouseButton
	if button == null or not button.pressed:
		return
	if button.button_index == MOUSE_BUTTON_WHEEL_UP:
		_distance -= zoom_step
		_apply_zoom()
	elif button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		_distance += zoom_step
		_apply_zoom()


func _process(delta: float) -> void:
	if not active:
		if follow_target != null:
			global_position = follow_target.global_position
		return

	var turn: float = Input.get_axis(InputActions.ROTATE_RIGHT, InputActions.ROTATE_LEFT)
	rotate_y(turn * rotate_speed * delta)

	var input: Vector2 = Input.get_vector(
		InputActions.MOVE_LEFT, InputActions.MOVE_RIGHT,
		InputActions.MOVE_FORWARD, InputActions.MOVE_BACK)
	# Pan faster when zoomed out so it feels the same at every height.
	var speed: float = pan_speed * (_distance / 40.0)
	global_position += global_basis * Vector3(input.x, 0.0, input.y) * speed * delta
	_snap_to_ground()


## Keeps the focus point on the terrain surface so hills don't swallow the view.
func _snap_to_ground() -> void:
	var from := global_position + Vector3.UP * 200.0
	var to := global_position + Vector3.DOWN * 200.0
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1  # Terrain only.
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		global_position.y = (hit["position"] as Vector3).y


func _apply_zoom() -> void:
	_distance = clampf(_distance, min_distance, max_distance)
	if camera != null:
		camera.position = Vector3(0.0, 0.0, _distance)
