extends Node

@export var rig_animation_player: AnimationPlayer
@export var weapon_animation_player: AnimationPlayer


func _ready() -> void:
	rig_animation_player.play("FP_Idle")
	weapon_animation_player.play("GUN_Idle")
