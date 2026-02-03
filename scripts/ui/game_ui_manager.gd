extends Node

@export_group("Ammo Check")
@export var ammo_check: Control
@export var ammo_check_visible: bool = false

@export_group("Hitmarker")
@export var hitmarker: Control
@export var hitmarker_visible: bool = false


func _process(_delta):
	if ammo_check_visible:
		ammo_check.modulate.a = lerp(ammo_check.modulate.a, 1.0, 0.1)
	else:
		ammo_check.modulate.a = lerp(ammo_check.modulate.a, 0.0, 0.1)

	if hitmarker_visible:
		hitmarker.modulate.a = lerp(hitmarker.modulate.a, 1.0, 0.5)
		if hitmarker.modulate.a == 1.0:
			hitmarker_visible = false
	else:
		hitmarker.modulate.a = lerp(hitmarker.modulate.a, 0.0, 0.5)


func show_crosshair():
	hitmarker_visible = true


func hide_crosshair():
	hitmarker_visible = false


func show_ammo_check(ammo_type: String, ammo_amount: String):
	ammo_check_visible = true
	ammo_check.update_ammo(ammo_type, ammo_amount)


func hide_ammo_check():
	ammo_check_visible = false


func show_dialogue_menu():
	CursorManager.unlock_mouse()
	# dialogue_menu.update_dialogue(dialogue_type)


func hide_dialogue_menu():
	CursorManager.lock_mouse()
