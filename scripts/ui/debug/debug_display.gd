extends Node

@export var fps_label: Label

func _process(delta):
	fps_label.text = str(Engine.get_frames_per_second())
