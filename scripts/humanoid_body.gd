class_name HumanoidBody
extends CharacterBody3D
## The "body": physics, gravity and movement only. It never reads input.
## A brain (PlayerBrain now, NPC brains later) writes the intent fields below.

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var jump_velocity: float = 5.5
@export var acceleration: float = 12.0
@export var air_control: float = 0.3
@export var min_pitch_deg: float = -89.0
@export var max_pitch_deg: float = 89.0

## Desired horizontal direction in world space, length 0..1.
var move_intent: Vector3 = Vector3.ZERO
var sprint_intent: bool = false
## Set true for one physics tick to request a jump.
var jump_intent: bool = false
## When frozen the body ignores physics (used while terrain under it loads).
var frozen: bool = true

@onready var head: Node3D = $Head

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)


func look(yaw_delta: float, pitch_delta: float) -> void:
	rotate_y(yaw_delta)
	var pitch: float = head.rotation.x + pitch_delta
	head.rotation.x = clampf(pitch, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))


func _physics_process(delta: float) -> void:
	if frozen:
		velocity = Vector3.ZERO
		jump_intent = false
		return

	if not is_on_floor():
		velocity.y -= _gravity * delta
	elif jump_intent:
		velocity.y = jump_velocity
	jump_intent = false

	var speed: float = sprint_speed if sprint_intent else walk_speed
	var target: Vector3 = move_intent.limit_length(1.0) * speed
	var accel: float = acceleration if is_on_floor() else acceleration * air_control
	var horizontal := Vector3(velocity.x, 0.0, velocity.z).lerp(target, clampf(accel * delta, 0.0, 1.0))
	velocity.x = horizontal.x
	velocity.z = horizontal.z

	move_and_slide()
