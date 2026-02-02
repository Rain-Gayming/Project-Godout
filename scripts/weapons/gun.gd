class_name Gun
extends Node

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

@export_group("Timers")
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


func shoot():
	if !can_shoot:
		if checking_ammo:
			checking_ammo = false
			ammo_check_delay_timer.stop()
			ammo_check_timer.stop()
			ammo_check_fade_timer.stop()
			GameUi.hide_ammo_check()
			return

	var bullet = bullet_scene.instantiate()
	bullet.global_transform = muzzle_point.global_transform
	get_tree().get_root().add_child(bullet)

	var final_velocity = (
		(bullet_info.base_velocity * bullet_info.weight)
		* (gun_info.barrel_length)
		* gun_info.barrel_condition
	)
	weapon_holder.shoot()
	bullet.fire(final_velocity)


func ammo_check():
	print("Checking ammo")
	ammo_check_timer.start()
	ammo_check_delay_timer.start()
	ammo_check_fade_timer.start()
	checking_ammo = true
	can_shoot = false


func _ammo_check_timer_delay_timeout() -> void:
	print("Impliment ammo check bitch")
	ammo_check_delay_timer.stop()
	GameUi.show_ammo_check(ammo_type, calculate_ammo_amount())


func _ammo_check_fade_timer_timeout() -> void:
	print("Fade out ammo check")
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
