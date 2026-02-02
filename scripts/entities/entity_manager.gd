class_name EntityManager
extends Node

@export var health_manager: HealthManager


func hit(damage: int):
	health_manager.health -= damage
