class_name HealthManager
extends Node

@export var health: int = 100
@export var max_health: int = 100

@export var model: CSGMesh3D


func _ready() -> void:
	model.material = model.material.duplicate()


func _process(delta: float) -> void:
	var red = (max_health - health) * 2
	model.material.albedo_color = Color(red, 0, 0)
