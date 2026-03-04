extends Node

var lucidity: float = 100.0
var lucidity_drain_per_sec: float = 5.0

var collapse_duration: float = 15.0
var in_dive: bool = false
var in_collapse: bool = false
var collapse_time_left: float = 0.0

signal lucidity_changed(value: float)
signal collapse_started(duration: float)
signal collapse_time_changed(time_left: float)


func _process(delta: float) -> void:
	
	if not in_dive:
		return
		
	if not in_collapse:
		lucidity -= lucidity_drain_per_sec * delta
		if lucidity <= 0.0:
			lucidity = 0.0
		emit_signal("lucidity_changed", lucidity)
		if lucidity <= 0.0:
			start_collapse()
	else:
		collapse_time_left -= delta
		emit_signal("collapse_time_changed", collapse_time_left)
		if collapse_time_left <= 0.0:
			collapse_time_left = 0.0
			fail_run()
		

func begin_dive() -> void:
	
	lucidity = 100.0
	in_dive = true
	
	in_collapse = false
	collapse_time_left = 0

func request_extract() -> void:
	if not in_dive:
		return
		
	if in_collapse and collapse_time_left <= 0:
		return
	
	succeed_run()


func start_collapse() -> void:
	if in_collapse:
		return
	in_collapse = true
	collapse_time_left = collapse_duration
	emit_signal("collapse_started", collapse_duration)
	emit_signal("collapse_time_changed", collapse_time_left)
	print("COLLAPSE STARTED")


func fail_run() -> void:
	print("DIVE FAILED")
	in_dive = false
	in_collapse = false
	GameFlow.goto_hub()

func succeed_run() -> void:
	print("DIVE SUCCEEDED")
	in_dive = false
	in_collapse = false
	GameFlow.goto_hub()
