extends Node2D

@onready var start_dive_button: Button = $CanvasLayer/Control/StartDiveButton
@onready var spawn: Marker2D = $Spawn


func _ready() -> void:
	start_dive_button.pressed.connect(_on_start_dive_pressed)

func _on_start_dive_pressed() -> void:
	GameFlow.start_dive()

func get_spawn() -> Vector2:
	return spawn.global_position
