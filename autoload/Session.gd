extends Node

enum State { HUB, IN_DIVE, COLLAPSE }

var state: State = State.HUB

var hub_scene: PackedScene = preload("res://scenes/hub/Hub.tscn")
var dive_scene: PackedScene = preload("res://scenes/dive/Dive.tscn")


func start_dive() -> void:

	if state != State.HUB:
		return
		
	state = State.IN_DIVE
	get_tree().change_scene_to_packed(dive_scene)
	
	Run.begin_dive()
		

func goto_hub() -> void:

	state = State.HUB
	get_tree().change_scene_to_packed(hub_scene)
