class_name Casing
extends RigidBody3D


func fire(speed):
	linear_velocity = -basis.z * speed
