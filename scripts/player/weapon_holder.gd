class_name WeaponHolder
extends Node3D

@export var weapon: Node
@export_group("Aiming")
@export var aiming: bool
@export var aim_position: Marker3D
@export var hip_position: Marker3D
@export var aim_control: float = 0.5

@export_group("Sway")
@export_group("Sway/Settings")
@export var sway_amount := 0.1
@export var sway_speed := 10.0
@export var max_sway := 0.3
@export var divider = 10

@export_group("Sway/Inputs")
@export var velocity := Vector3.ZERO
@export var mouse_delta := Vector2.ZERO

@export_group("Sway/Debug")
@export var current_sway := Vector3.ZERO
@export var total_rotation_sway := Vector3.ZERO
@export var total_position_sway := Vector3.ZERO
@export var initial_position := Vector3.ZERO

@export_group("Sway/Position")
@export var position_sway_amount := 0.05
@export var max_position_sway := 0.2

@export_group("Sway/Position/Debug")
@export var current_position_sway := Vector3.ZERO

@export_group("Sway/Camera")
@export var look_sway_amount := 0.15
@export var look_position_sway := 0.03
@export var look_sway_speed := 8.0

@export_group("Sway/Camera/Debug")
@export var current_look_sway := Vector3.ZERO
@export var current_look_position_sway := Vector3.ZERO

@export_group("Recoil")
@export var recoil: Recoil

@export_group("Recoil/Debug")
@export var recoil_rot := Vector3.ZERO
@export var recoil_pos := Vector3.ZERO

@export_group("Wall Detection")
@export var wall_raycast: RayCast3D
@export var pull_raycast: RayCast3D
@export var max_rotation := 110.0
@export var rotation_speed := 5.0
@export var safe_distance := 1.5
@export var pullback_speed := 8.0  # Add this

@export_group("Wall Detection/Debug")
@export var target_rotation: float
@export var current_wall_rotation: float = 0.0
@export var pull_back: Vector3
@export var current_pull_back: Vector3 = Vector3.ZERO

var move_blend_y = -1.0


func _ready():
	initial_position = hip_position.position


func _process(delta):
	if !CursorManager.cursor_locked:
		return
	# Aiming
	if Input.is_action_just_pressed("combat_aim"):
		aiming = !aiming
	if aiming:
		initial_position = lerp(initial_position, aim_position.position, delta * 10)
	else:
		aiming = false
		initial_position = lerp(initial_position, hip_position.position, delta * 10)

	if velocity.x == 0.0 and velocity.z == 0.0:
		move_blend_y = max(move_blend_y - delta * 2.5, -1.0)
	else:
		move_blend_y = min(move_blend_y + delta * 2.5, 0.0)

	weapon.body_animation_tree["parameters/StateMachine/IdleWalkBlend/blend_position"].y = move_blend_y
	weapon.weapon_animation_tree["parameters/StateMachine/IdleWalkBlend/blend_position"].y = move_blend_y

	calculate_sway(delta)
	detect_wall(delta)
	apply()
	# Reset mouse delta
	mouse_delta = Vector2.ZERO


func calculate_sway(delta: float):
	# calculate sway
	var target_sway = (
		Vector3(velocity.x * sway_amount, velocity.y * sway_amount, velocity.z * sway_amount)
		/ divider
	)
	var target_position_sway = (
		Vector3(
			velocity.x * position_sway_amount,
			velocity.y * position_sway_amount,
			velocity.z * position_sway_amount
		)
		/ divider
	)
	var target_look_sway = (
		Vector3(mouse_delta.x * look_sway_amount, mouse_delta.y * look_sway_amount, 0.0) / divider
	)
	var target_look_position_sway = (
		Vector3(
			mouse_delta.x * look_position_sway,
			mouse_delta.y * look_position_sway,
			0.0,
		)
		/ divider
	)

	# clamp to maximum values
	target_sway = target_sway.limit_length(max_sway)
	target_position_sway = target_position_sway.limit_length(max_position_sway)
	target_look_sway = target_look_sway.limit_length(max_sway)
	target_look_position_sway = target_look_position_sway.limit_length(max_position_sway)

	# interpolate to target sway
	current_sway = current_sway.lerp(target_sway, sway_speed * delta)
	current_position_sway = current_position_sway.lerp(target_position_sway, sway_speed * delta)
	current_look_sway = current_look_sway.lerp(target_look_sway, look_sway_speed * delta)
	current_look_position_sway = current_look_position_sway.lerp(
		target_look_position_sway, look_sway_speed * delta
	)

	# combine movement and look sway
	total_rotation_sway = current_sway + current_look_sway
	total_position_sway = current_position_sway + current_look_position_sway


func detect_wall(delta: float):
	if wall_raycast.is_colliding():
		var collision_point = wall_raycast.get_collision_point()
		var distance = global_position.distance_to(collision_point)

		var rotation_amount = remap(distance, 0.0, safe_distance, max_rotation, 0.0)
		target_rotation = deg_to_rad(rotation_amount)
	else:
		target_rotation = 0.0

	# Smoothly interpolate wall rotation
	current_wall_rotation = lerp_angle(
		current_wall_rotation, target_rotation, rotation_speed * delta
	)

	# if pull_raycast.is_colliding():
	# 	var pull_collision_point = pull_raycast.get_collision_point()
	# 	var pull_distance = global_position.distance_to(pull_collision_point)
	#
	# 	var pull_amount = remap(pull_distance, 0.0, safe_distance, max_rotation, 0.0)
	# 	pull_back = Vector3(0.0, 0.0, pull_amount)
	# else:
	# 	pull_back = Vector3.ZERO

	# Smoothly interpolate pullback
	current_pull_back = current_pull_back.lerp(pull_back, pullback_speed * delta)


func apply():
	# get recoil values
	recoil_rot = recoil.get_recoil_rotation()
	recoil_pos = recoil.get_recoil_position()

	var additional_position = (
		Vector3(total_position_sway.x, total_position_sway.y, 0.0) + recoil_pos + current_pull_back
	)
	if aiming:
		total_rotation_sway.x *= aim_control
		total_rotation_sway.y *= aim_control
		total_rotation_sway.z *= aim_control
		additional_position *= aim_control
	# apply rotational sway + recoil (use smoothed wall rotation)

	rotation.x = (total_rotation_sway.y + deg_to_rad(recoil_rot.x) + current_wall_rotation)
	rotation.y = (deg_to_rad(recoil_rot.y))
	rotation.z = (total_rotation_sway.x + deg_to_rad(recoil_rot.z))

	# apply positional sway + recoil (use smoothed pullback)
	position = initial_position + additional_position


func shoot():
	recoil.apply_recoil()
