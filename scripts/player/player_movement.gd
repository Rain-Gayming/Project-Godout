class_name PlayerMovement
extends Node

@export var character_body: CharacterBody3D
@export var head: Node3D
@export var camera: Camera3D


@export_group("Movement")
@export var current_speed: float = 1
@export var walk_speed: float = 1
@export var run_speed: float = 2
@export var sprint_speed: float = 4
@export var acceleration: float = 1


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var direction = event.relative
		head.rotate_y(-direction.x * 0.005)
		camera.rotate_x(-direction.y * 0.005)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_forwards", "movement_backwards")

	var direction = (head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()

	if direction:
		character_body.velocity.x = move_toward(character_body.velocity.x, direction.x * current_speed, acceleration)
		character_body.velocity.z = move_toward(character_body.velocity.z, direction.z * current_speed, acceleration)
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, acceleration)
		character_body.velocity.z = move_toward(character_body.velocity.z, 0, acceleration)
	character_body.move_and_slide()	
