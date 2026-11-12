extends Node3D
## Main scene glue: input setup, extension sanity check, safe player spawn, HUD.

@export var player: HumanoidBody
@export var camera_modes: CameraModeController
@export var hud_label: Label
## Spawn column (x, z). The player is held frozen until terrain collision
## exists under this point, then dropped onto the surface.
@export var spawn_xz: Vector2 = Vector2.ZERO
@export var spawn_probe_height: float = 300.0
## Where the player waits while frozen. Must be within the VoxelViewer's
## vertical view distance of the ground, or the ground never loads.
@export var spawn_hold_height: float = 64.0

const TERRAIN_LAYER_MASK: int = 1  # Terrain is on layer 1, the player on layer 2.
const MODE_NAMES: PackedStringArray = ["First person", "Third person", "Bird's-eye"]
const HELP_WALK := "WASD move  Mouse look  Space jump  Shift sprint  V camera  Esc free mouse"
const HELP_OVERHEAD := "WASD pan  Q/E rotate  Wheel zoom  V camera"


func _ready() -> void:
	InputActions.ensure_defaults()
	_report_voxel_classes()
	camera_modes.mode_changed.connect(_on_mode_changed)
	_on_mode_changed(camera_modes.mode)
	player.frozen = true
	player.global_position = Vector3(spawn_xz.x, spawn_hold_height, spawn_xz.y)


func _physics_process(_delta: float) -> void:
	if player.frozen:
		_try_spawn()


func _try_spawn() -> void:
	var from := Vector3(spawn_xz.x, spawn_probe_height, spawn_xz.y)
	var to := Vector3(spawn_xz.x, -spawn_probe_height, spawn_xz.y)
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = TERRAIN_LAYER_MASK
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return  # Terrain collision not built yet; try again next tick.
	player.global_position = (hit["position"] as Vector3) + Vector3.UP * 1.5
	player.frozen = false


func _report_voxel_classes() -> void:
	if not ClassDB.class_exists(&"VoxelTerrain"):
		push_error("godot_voxel GDExtension not loaded: check addons/zylann.voxel/voxel.gdextension.")
		return
	# GDExtension builds ship ZN_FastNoiseLite but not FastNoise2. The terrain
	# uses Godot's built-in FastNoiseLite because VoxelGeneratorNoise2D needs a `Noise`.
	print("Voxel noise classes: ZN_FastNoiseLite=%s FastNoise2=%s" % [
		ClassDB.class_exists(&"ZN_FastNoiseLite"), ClassDB.class_exists(&"FastNoise2")])


func _on_mode_changed(mode: CameraModeController.Mode) -> void:
	var help: String = HELP_OVERHEAD if mode == CameraModeController.Mode.BIRDS_EYE else HELP_WALK
	hud_label.text = "%s\n%s" % [MODE_NAMES[mode], help]
