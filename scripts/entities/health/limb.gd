class_name Limb
extends Resource

enum LimbEnum { HEAD, NECK, STOMACH, CHEST, LEFT_ARM, RIGHT_ARM, LEFT_LEG, RIGHT_LEG }

@export var limb: LimbEnum
@export var limb_health: int
@export var limb_max_health: int
@export var is_limb_dead: bool = false


func init() -> void:
	limb_health = limb_max_health


func damaged(damage: int) -> void:
	print(limb_health)
	if limb_health <= 0:
		return

	match limb:
		LimbEnum.HEAD:
			limb_health -= damage * 1.75
		LimbEnum.NECK:
			limb_health -= damage * 1.75
		LimbEnum.STOMACH:
			limb_health -= damage * 1.75
		LimbEnum.CHEST:
			limb_health -= damage * 1.75
		LimbEnum.LEFT_ARM:
			limb_health -= damage * 1.15
		LimbEnum.RIGHT_ARM:
			limb_health -= damage * 1.15
		LimbEnum.LEFT_LEG:
			limb_health -= damage * 1.15
		LimbEnum.RIGHT_LEG:
			limb_health -= damage * 1.15

	print(damage)
	limb_health -= damage

	if limb_health <= 0:
		is_limb_dead = true
		print("Limb %s is dead" % limb)

	limb_health = clamp(limb_health, 0, limb_max_health)
