class_name LimbHitbox
extends Hitbox

@export var limb: Limb.LimbEnum
@export var health_manager: HealthManager


func hit(damage: int) -> void:
	health_manager.damage(damage, limb)
