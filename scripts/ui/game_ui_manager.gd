extends Node

@export var ammo_check: Control
@export var ammo_check_visible: bool = false

@export var dialogue_menu: Control
@export var dialogue_menu_visible: bool = false


func _process(_delta):
	if ammo_check_visible:
		ammo_check.modulate.a = lerp(ammo_check.modulate.a, 1.0, 0.1)
	else:
		ammo_check.modulate.a = lerp(ammo_check.modulate.a, 0.0, 0.1)

	if dialogue_menu_visible:
		dialogue_menu.modulate.a = lerp(dialogue_menu.modulate.a, 1.0, 0.1)
	else:
		dialogue_menu.modulate.a = lerp(dialogue_menu.modulate.a, 0.0, 0.1)


func show_ammo_check(ammo_type: String, ammo_amount: String):
	ammo_check_visible = true
	ammo_check.update_ammo(ammo_type, ammo_amount)


func hide_ammo_check():
	ammo_check_visible = false


func show_dialogue_menu():
	dialogue_menu_visible = true
	CursorManager.unlock_mouse()
	# dialogue_menu.update_dialogue(dialogue_type)


func hide_dialogue_menu():
	dialogue_menu_visible = false
	CursorManager.lock_mouse()
