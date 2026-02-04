class_name InventoryGrid
extends GridContainer

@export var parent_container: ItemContainer
@export var inventory_slot_scene: PackedScene
@export var dimentions: Vector2i
@export var padding: Vector2
@export var slot_size: int = 64
@export var slot_data: Array[ContainerItemSlot] = []
var held_item_intersects: bool = false


func _ready() -> void:
	create_slots()
	init_slot_data()


func create_slots():
	self.columns = dimentions.x
	for y in dimentions.y:
		for x in dimentions.x:
			var new_item_slot = inventory_slot_scene.instantiate()
			add_child(new_item_slot)


func init_slot_data():
	slot_data.resize(dimentions.x * dimentions.y)
	slot_data.fill(null)


func _process(delta):
	if Input.is_action_just_pressed("left_mouse"):
		mouse_press()


func mouse_press() -> void:
	var index = get_slot_index_from_coords(get_global_mouse_position())
	var held_item = get_tree().get_first_node_in_group("held_item")

	if not held_item:
		var item = slot_data[index]
		if not item:
			return

		print("item: " + str(item))
		item.get_picked_up()
		remove_item_from_slot_data(item)
	else:
		# var equipment_slot = parent_container.is_equipment_slot_hovered()
		# if equipment_slot:
		# 	if equipment_slot.compare_items(held_item.data):
		# 		held_item.queue_free()
		# 	return

		var offset = Vector2(slot_size, slot_size) / 2
		var slot_index = get_slot_index_from_coords(held_item.anchor_point + offset)

		var items = items_in_area(index, held_item.data.item.item_size)
		if items and items.size():
			if items.size() == 1:
				held_item.get_placed(get_coords_from_slot_index(index))
				remove_item_from_slot_data(items[0])
				add_item_to_slot_data(index, held_item)
				items[0].get_picked_up()
			return
		held_item.get_placed(get_coords_from_slot_index(slot_index))
		add_item_to_slot_data(index, held_item)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var held_item = get_tree().get_first_node_in_group("held_item")
		if held_item:
			detect_held_item_intersection(held_item)


func remove_container_item_from_slot_data(item: ContainerItem):
	for index in slot_data.size():
		if slot_data[index] == null:
			continue
		if slot_data[index].data == item:
			slot_data[index].queue_free()
			slot_data[index] = null
			return

	print("item couldnt be found in slot data")


func remove_item_from_slot_data(item: ContainerItemSlot):
	for index in slot_data.size():
		if slot_data[index] == item:
			slot_data[index] = null


func add_item_to_slot_data(index: int, item: ContainerItemSlot):
	for y in item.data.item.item_size.y:
		for x in item.data.item.item_size.x:
			if index + x + y * columns < slot_data.size():
				slot_data[index + x + y * columns] = item.duplicate()


func items_in_area(index: int, item_dimentions: Vector2i):
	var items: Dictionary = {}
	for y in item_dimentions.y:
		for x in item_dimentions.x:
			var slot_index = index + x + y * columns
			if slot_index >= dimentions.x * dimentions.y:
				return null

			var item = slot_data[slot_index]
			if !item:
				continue
			if !items.has(item):
				items[item] = true
	return items.keys() if items.size() else []


func detect_held_item_intersection(held_item: ContainerItemSlot):
	var h_rect = Rect2(held_item.anchor_point, held_item.size)
	var g_rect = Rect2(global_position, size)
	var intersection = h_rect.intersection(g_rect).size
	held_item_intersects = (
		(
			(intersection.x * intersection.y)
			/ (held_item.data.item.item_size.x * held_item.data.item.item_size.y)
		)
		> 0.80
	)


func get_slot_index_from_coords(coords: Vector2i) -> int:
	coords -= Vector2i(self.global_position)
	coords = coords / slot_size

	var index = coords.x + coords.y * columns

	if index > dimentions.x * dimentions.y || index < 0:
		return -1

	print("slot index: " + str(index))
	print("coords: " + str(coords))
	return index


func get_coords_from_slot_index(index: int) -> Vector2i:
	var row = index / columns
	var column = index % columns
	return Vector2i(global_position) + Vector2i(column * slot_size, row * slot_size)


func attempt_to_add_item_data(item: ContainerItemSlot) -> bool:
	var data = item.data.item
	var slot_index: int = 0

	while slot_index < slot_data.size():
		if item_fits(slot_index, item.data.current_size):
			break
		slot_index += 1

	if slot_index >= slot_data.size():
		return false

	for y in data.item_size.y:
		for x in data.item_size.x:
			slot_data[slot_index + x + y * columns] = item

	print("adding to inventory grid: " + str(item.data))
	item.set_init_position(get_coords_from_slot_index(slot_index))
	return true


func item_fits(index: int, dimentions: Vector2i) -> bool:
	for y in dimentions.y:
		for x in dimentions.x:
			var current_index = index + x + y * columns
			if current_index >= slot_data.size():
				return false
			if slot_data[current_index] != null:
				return false

			var split = index / columns != (index + x) / columns
			if split:
				return false

	return true
