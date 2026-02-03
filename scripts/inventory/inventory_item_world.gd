extends RigidBody3D

var is_dragging = false
var drag_distance = 100.0
var target_position = Vector3.ZERO
var drag_speed = 20.0  # How fast it moves to target position


func _ready():
	input_ray_pickable = true


func _input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_dragging = true
			var camera = get_viewport().get_camera_3d()
			drag_distance = camera.global_position.distance_to(global_position)
			freeze = false


func _input(event):
	if event is InputEventMouseButton:
		# Check for mouse release anywhere
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if is_dragging:
				is_dragging = false

		if is_dragging:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				drag_distance -= 0.1
				drag_distance = max(drag_distance, 0.5)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				drag_distance += 0.1

	if is_dragging and event is InputEventMouseMotion:
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(event.position)
		var direction = camera.project_ray_normal(event.position)

		target_position = from + direction * drag_distance


func _physics_process(delta):
	if is_dragging:
		var direction_to_target = target_position - global_position
		linear_velocity = direction_to_target * drag_speed

		angular_velocity *= 0.9
	else:
		linear_velocity *= 0.98
