extends Node

var cursor_locked: bool = false


func lock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cursor_locked = true


func unlock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cursor_locked = false
