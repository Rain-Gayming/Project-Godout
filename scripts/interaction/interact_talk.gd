class_name InteractTalk
extends Interactable

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
const Balloon = preload("res://scenes/ui/dialogue/balloon.tscn")
var in_dialogue: bool = false
@export var current_balloon: Node

func _process(delta: float) -> void:
	if in_dialogue:
		if current_balloon == null:
			in_dialogue = false
			GameUi.hide_dialogue_menu()
		

func interact():
	in_dialogue = true
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
	current_balloon = balloon
	GameUi.show_dialogue_menu()
