extends Node

@export var ammo_check: Control
@export var ammo_check_visible: bool = false


func _process(_delta):
	if ammo_check_visible:
		ammo_check.modulate.a = lerp(ammo_check.modulate.a, 1.0, 0.1)
	else:
		ammo_check.modulate.a = lerp(ammo_check.modulate.a, 0.0, 0.1)


func show_ammo_check(ammo_type: String, ammo_amount: String):
	ammo_check_visible = true
	ammo_check.update_ammo(ammo_type, ammo_amount)


func hide_ammo_check():
	ammo_check_visible = false
