class_name ContainerItemSlot
extends Sprite2D

@export var data: ContainerItem
@export var gp: Vector2
@export var is_picked: bool
@export var information_text: Label

var size: Vector2:
	get():
		return Vector2(data.current_size.x, data.current_size.y) * 64

var anchor_point: Vector2:
	get():
		return global_position - size / 2


func _ready() -> void:
	if data:
		texture = data.item.item_icon


func _process(delta):
	information_text.text = data.item.get_slot_details()
	if is_picked:
		global_position = get_global_mouse_position()

		if Input.is_action_just_pressed("inventory_rotate"):
			do_rotation()


func set_init_position(pos: Vector2):
	print("i have item: " + str(data))
	global_position = pos + size / 2
	anchor_point = global_position - size / 2
	information_text.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	information_text.position = size / -2


func get_picked_up():
	add_to_group("held_item")
	is_picked = true
	z_index = 255
	anchor_point = global_position - size / 2


func get_placed(pos: Vector2i):
	is_picked = false
	global_position = pos + Vector2i(size) / 2
	z_index = 0
	anchor_point = global_position - size / 2
	remove_from_group("held_item")


func do_rotation():
	data.is_rotated = !data.is_rotated

	if data.is_rotated:
		data.current_size = Vector2(data.item.item_size.y, data.item.item_size.x)
		texture = data.item.item_icon_rotated
		information_text.rotation_degrees = 0
		information_text.position = size / -2
		information_text.size = size
	else:
		data.current_size = Vector2(data.item.item_size.x, data.item.item_size.y)
		texture = data.item.item_icon
		information_text.rotation_degrees = -90
		information_text.size = Vector2(size.x, size.y)
		information_text.position = Vector2(size.y / -2, size.x)

	anchor_point = global_position - size / 2
