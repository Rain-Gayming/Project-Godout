extends Node
class_name Recoil

# Recoil settings
@export var recoil_rotation := Vector3(15.0, 0.0, 0.0)
@export var recoil_position := Vector3(0.0, 0.0, -0.1)
@export var recoil_speed := 15.0
@export var recoil_return_speed := 8.0
@export var recoil_randomness := 5.0

# Recoil state
var current_recoil_rotation := Vector3.ZERO
var current_recoil_position := Vector3.ZERO
var target_recoil_rotation := Vector3.ZERO
var target_recoil_position := Vector3.ZERO


func _process(delta):
	if target_recoil_rotation.length() > 0.01:
		current_recoil_rotation = current_recoil_rotation.lerp(
			target_recoil_rotation, recoil_speed * delta
		)
		current_recoil_position = current_recoil_position.lerp(
			target_recoil_position, recoil_speed * delta
		)

		if current_recoil_rotation.distance_to(target_recoil_rotation) < 0.5:
			target_recoil_rotation = Vector3.ZERO
			target_recoil_position = Vector3.ZERO
	else:
		current_recoil_rotation = current_recoil_rotation.lerp(
			Vector3.ZERO, recoil_return_speed * delta
		)
		current_recoil_position = current_recoil_position.lerp(
			Vector3.ZERO, recoil_return_speed * delta
		)


# Call this when the gun fires
func apply_recoil():
	# Add random horizontal recoil
	var random_horizontal = randf_range(-recoil_randomness, recoil_randomness)

	target_recoil_rotation = (recoil_rotation + Vector3(0, -random_horizontal, 0))
	target_recoil_position = recoil_position


# Get the current recoil values to apply to your object
func get_recoil_rotation() -> Vector3:
	return current_recoil_rotation


func get_recoil_position() -> Vector3:
	return current_recoil_position
