class_name ItemResource
extends Resource

@export var item_name: String
@export var item_description: String
@export var item_icon: Texture
@export var item_icon_rotated: Texture
@export var can_stack: bool
@export var item_type: String
@export var item_weight: float
@export var item_value: int
@export var item_size: Vector2


func get_slot_details() -> String:
	return ""
