class_name BulletInfo
extends Resource

@export_group("Type info")
@export var caliber: AmmoEnums.Caliber
@export var bullet_type: AmmoEnums.BulletType

@export_group("Damage info")
@export var damage: int
@export var penetration: int
@export var weight: float

@export_group("Velocity info")
@export var base_velocity: float
@export var bullet_condition: float
