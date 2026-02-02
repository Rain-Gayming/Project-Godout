class_name Bullet
extends RigidBody3D

@export var bullet_info: BulletInfo


func fire(speed):
	linear_velocity = -basis.x * speed


var previous_position


func _ready():
	previous_position = global_position


func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(previous_position, global_position)
	var result = space_state.intersect_ray(query)

	if result:
		var collider: Node = result.collider
		if collider.name != "Player":
			if collider.has_method("hit"):
				collider.hit(bullet_info.damage)
				GameUi.show_crosshair()
				queue_free()

	previous_position = global_position
