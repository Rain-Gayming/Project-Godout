class_name Camera
extends Node

@export var interaction_raycast: RayCast3D


func _process(delta):
	if Input.is_action_just_pressed("game_interact"):
		if interaction_raycast.is_colliding():
			if interaction_raycast.get_collider() is Interactable:
				interaction_raycast.get_collider().interact()
