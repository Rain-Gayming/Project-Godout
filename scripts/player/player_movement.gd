class_name PlayerMovement
extends Node

@export var character_body: CharacterBody3D
@export var head: Node3D
@export var camera: Camera3D
@export var weapon_holder: WeaponHolder

@export_group("Movement")
@export var current_speed: float = 1
@export var walk_speed: float = 1
@export var run_speed: float = 2
@export var sprint_speed: float = 4
@export var acceleration: float = 1

@export_group("Jumping & Gravity")
@export var jump_speed: float = 10
@export var gravity: float = 10
@export var air_control: float = 0.5


func _input(event: InputEvent) -> void:
	if !CursorManager.cursor_locked:
		return

	if event is InputEventMouseMotion:
		var direction = event.relative
		head.rotate_y(-direction.x * 0.005)
		camera.rotate_x(-direction.y * 0.005)
		weapon_holder.mouse_delta = direction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CursorManager.lock_mouse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !CursorManager.cursor_locked:
		return

	directional_movement()
	jump_and_gravity(delta)
	character_body.move_and_slide()


func directional_movement() -> void:
	var input_direction = Input.get_vector(
		"movement_left", "movement_right", "movement_forwards", "movement_backwards"
	)

	var direction = (
		(head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	)
	weapon_holder.velocity = character_body.velocity

	# moves the player based on their direction
	if direction:
		character_body.velocity.x = move_toward(
			character_body.velocity.x, direction.x * current_speed, acceleration
		)
		character_body.velocity.z = move_toward(
			character_body.velocity.z, direction.z * current_speed, acceleration
		)
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, acceleration)
		character_body.velocity.z = move_toward(character_body.velocity.z, 0, acceleration)

	# slows the player down when in the air
	if !character_body.is_on_floor():
		character_body.velocity.x = move_toward(
			character_body.velocity.x, direction.x * current_speed * air_control, acceleration
		)
		character_body.velocity.z = move_toward(
			character_body.velocity.z, direction.z * current_speed * air_control, acceleration
		)


func jump_and_gravity(delta: float) -> void:
	# jump
	if Input.is_action_just_pressed("movement_jump") and character_body.is_on_floor():
		character_body.velocity.y = jump_speed

	# gravity
	if !character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta
