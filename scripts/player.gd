extends CharacterBody2D

signal interact_pressed

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		print("pressed")
		interact_pressed.emit()
