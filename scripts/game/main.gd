extends Node2D

@onready var scene_root: Node2D = $SceneRoot

func _ready() -> void:
	GameFlow.init(scene_root)
	GameFlow.goto_hub()
