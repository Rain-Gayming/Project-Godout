class_name ItemContainer
extends Node

@export var items_in_inventory: Array[ContainerItem]
@export var container_item_slot_scene: PackedScene

# @export var equipment_slots: Array[EquipmentSlot]
@export var container_ui: Control
@export var item_grid = GridContainer

@export_group("Debug")
@export var debug_item: ContainerItem


func _ready():
	for item in items_in_inventory:
		var index = items_in_inventory.find(item)
		item = item.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
		items_in_inventory[index] = item
		add_item_to_ui(item)


func _process(_delta):
	if Input.is_action_just_pressed("inventory_open"):
		container_ui.visible = !container_ui.visible
		CursorManager.toggle_cursor_lock()
	if Input.is_action_just_pressed("ui_accept"):
		add_item(debug_item.duplicate())


func check_for_item(item_to_check_for: ItemResource) -> ContainerItem:
	for item in items_in_inventory:
		if item.item.item_name == item_to_check_for.item_name:
			return item
	return null


func remove_item(item_to_remove: ContainerItem):
	var index = items_in_inventory.find(item_to_remove)
	print("erasing: " + str(index))

	items_in_inventory.erase(item_to_remove)
	print("item to remove: " + str(item_to_remove))
	item_grid.remove_container_item_from_slot_data(item_to_remove)


func remove_first_item(item_to_remove: ItemResource):
	for item in items_in_inventory:
		if item.item == item_to_remove:
			var index = items_in_inventory.find(item)
			items_in_inventory.remove_at(index)
			return


func add_item(item_to_add: ContainerItem):
	if item_to_add.current_size == Vector2(0, 0):
		item_to_add.current_size = item_to_add.item.item_size

	if not item_to_add.item.can_stack:
		add_new_item(item_to_add)
		return

	for item in items_in_inventory:
		if item.item == item_to_add.item:
			add_existing_item(item_to_add, item)

	add_new_item(item_to_add)


func add_existing_item(item_to_add: ContainerItem, existing_item: ContainerItem):
	existing_item.amount = existing_item.amount + item_to_add.amount


func add_new_item(item_to_add: ContainerItem):
	items_in_inventory.append(item_to_add)
	add_item_to_ui(item_to_add)


func add_item_to_ui(item_to_add: ContainerItem):
	var new_item_slot = container_item_slot_scene.instantiate()
	new_item_slot.data = item_to_add
	container_ui.add_child(new_item_slot)

	print("i have retrieved: " + str(item_to_add))
	var _success = item_grid.attempt_to_add_item_data(new_item_slot)

# func is_equipment_slot_hovered() -> EquipmentSlot:
# 	for slot in equipment_slots:
# 		if slot.is_hovered:
# 			return slot
#
# 	return null
