extends Node

func lock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func unlock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
