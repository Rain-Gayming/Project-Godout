class_name AmmoCheckUI
extends Node

@export var ammo_type_label: RichTextLabel
@export var ammo_amount_label: RichTextLabel


func update_ammo(ammo_type: String, ammo_amount: String):
	ammo_type_label.text = ammo_type
	ammo_amount_label.text = ammo_amount
