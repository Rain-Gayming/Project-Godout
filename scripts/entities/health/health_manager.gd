class_name HealthManager
extends Node

@export var total_health: int
@export var total_max_health: int
@export var limbs: Array[Limb]
@export var base: Node3D
@export var limbs_dead: Array[Limb]


func _ready() -> void:
	for limb in limbs:
		total_health += limb.limb_health
		total_max_health += limb.limb_max_health
		limb.init()


func damage(damage: int, limb: Limb.LimbEnum) -> void:
	total_health -= damage
	limbs[limb].damaged(damage)

	if limbs[limb].is_limb_dead && !limbs_dead.has(limbs[limb]):
		limbs_dead.append(limbs[limb])

	# If too many limbs are dead the entity dies
	if limbs_dead.size() >= 4:
		base.call_deferred("queue_free")

	# If the head or chest are out of health the entity dies
	if limbs[limb].limb == Limb.LimbEnum.HEAD or limbs[limb].limb == Limb.LimbEnum.CHEST:
		if limbs[limb].is_limb_dead:
			print("Entity is dead")
			base.call_deferred("queue_free")
