class_name Gun
extends Node

@export var pip_scope: Node3D
@export var weapon_holder: WeaponHolder
@export var muzzle_point: Marker3D
@export var bullet_scene: PackedScene

@export var gun_info: GunInfo
@export var bullet_info: BulletInfo

@export var can_shoot: bool = true
@export var checking_ammo: bool = false

@export var ammo_type: String = "5.56x45mm"
@export var ammo_amount: int = 30
@export var magazine_capacity: int = 30

@export var is_jammed: bool = false
@export_group("Timers")
@export_group("Timers/Reload")
@export var reload_timer: Timer
@export_group("Timers/Ammo Check")
@export var ammo_check_timer: Timer
@export var ammo_check_delay_timer: Timer
@export var ammo_check_fade_timer: Timer


func _process(_delta):
	if !CursorManager.cursor_locked:
		return

	if Input.is_action_just_pressed("combat_shoot"):
		shoot()

	if Input.is_action_just_pressed("ammo_check"):
		ammo_check()
	elif Input.is_action_just_pressed("combat_reload"):
		reload_timer.start()

	if Input.is_action_just_pressed("combat_aim"):
		pip_scope.visible = !pip_scope.visible


func shoot():
	if !can_shoot:
		if checking_ammo:
			checking_ammo = false
			ammo_check_delay_timer.stop()
			ammo_check_timer.stop()
			ammo_check_fade_timer.stop()
			GameUi.hide_ammo_check()
			return

	if ammo_amount <= 0:
		return

	if reload_timer.time_left > 0:
		return

	if is_jammed:
		return

	var bullet = bullet_scene.instantiate()
	bullet.global_transform = muzzle_point.global_transform
	get_tree().get_root().add_child(bullet)

	var final_velocity = (
		(bullet_info.base_velocity * bullet_info.weight)
		* (gun_info.barrel_length)
		* gun_info.barrel_condition
	)

	bullet.bullet_info = bullet_info
	weapon_holder.shoot()
	bullet.fire(final_velocity)
	ammo_amount -= 1

	var base_jam_rate = 2.0
	var bullet_impact = (100 - bullet_info.bullet_condition) / 100 * 3.0

	var receiver_impact = (100 - gun_info.receiver_condition) / 100 * 1.5
	var barrel_impact = (100 - gun_info.barrel_condition) / 100 * 0.8
	var jam_chance = (
		base_jam_rate * (1 + bullet_impact) * (1 + receiver_impact) * (1 + barrel_impact)
	)

	if randf_range(0, 100) < jam_chance:
		is_jammed = true


func ammo_check():
	print("Checking ammo")
	ammo_check_timer.start()
	ammo_check_delay_timer.start()
	ammo_check_fade_timer.start()
	checking_ammo = true
	can_shoot = false


func _ammo_check_timer_delay_timeout() -> void:
	ammo_check_delay_timer.stop()
	GameUi.show_ammo_check(ammo_type, calculate_ammo_amount())


func _ammo_check_fade_timer_timeout() -> void:
	GameUi.hide_ammo_check()


func _ammo_check_timer_timeout() -> void:
	can_shoot = true
	checking_ammo = false
	ammo_check_timer.stop()


func calculate_ammo_amount():
	var ammo_percentage = ammo_amount as float / magazine_capacity as float

	if ammo_percentage > 0.95:
		return "Full"
	elif ammo_percentage > 0.9:
		return "Almost Full"
	elif ammo_percentage > 0.75:
		return "More than Half"
	elif ammo_percentage > 0.5:
		return "Around Half"
	elif ammo_percentage > 0.25:
		return "Less than half"
	elif ammo_percentage > 0.0:
		return "Almost Empty"
	elif ammo_percentage == 0.0:
		return "Empty"


func _on_reload_timer_timeout() -> void:
	if is_jammed:
		is_jammed = false
		return
	ammo_amount = magazine_capacity
	reload_timer.stop()
