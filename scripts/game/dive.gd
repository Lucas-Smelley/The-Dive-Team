extends Node2D

@onready var spawn: Marker2D = $Spawn
@onready var anchor: Area2D = $Anchor

@onready var lucidity_label: Label = $CanvasLayer/Control/LucidityLabel
@onready var collapse_label: Label = $CanvasLayer/Control/CollapseLabel
@onready var extract_label: Label = $CanvasLayer/Control/ExtractLabel

var player: CharacterBody2D
var player_in_anchor := false
var players_in_anchor: int = 0

var extracting: bool = false
var extract_duration: float = 10.0
var extract_time_left: float = 0.0


func _ready() -> void:
	
	player = GameFlow.get_player()
	player.interact_pressed.connect(_on_player_interact)
	
	anchor.body_entered.connect(_on_anchor_body_entered)
	anchor.body_exited.connect(_on_anchor_body_exited)
	
	Run.lucidity_changed.connect(_on_lucidity_changed)
	Run.collapse_started.connect(_on_collapse_started)
	Run.collapse_time_changed.connect(_on_collapse_time_changed)
	
	collapse_label.visible = false
	collapse_label.text = ""

	extract_label.text = ""
	extract_label.visible = false
	
	_on_lucidity_changed(Run.lucidity)

func _process(delta: float) -> void:
	if extracting:
		extract_time_left -= delta
		extract_label.visible = true
		extract_label.text = "Extracting: %.1fs" % max(extract_time_left, 0.0)
		if extract_time_left <= 0: 
			extracting = false
			extract_time_left = 0
			
			if player_in_anchor:
				Run.request_extract()
			else:
				Run.fail_run()
	else:
		extract_label.visible = false
		extract_label.text = ""

func get_spawn() -> Vector2:
	return spawn.global_position


func _on_anchor_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		players_in_anchor += 1
		player_in_anchor = players_in_anchor > 0

func _on_anchor_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		players_in_anchor = max(players_in_anchor - 1, 0)
		player_in_anchor = players_in_anchor > 0


func _on_player_interact() -> void:
	if not player_in_anchor:
		return
	if extracting:
		return
	
	extracting = true
	extract_time_left = extract_duration
	
func _on_lucidity_changed(value: float) -> void:
	lucidity_label.text = "Lucidity: %d" % int(value)
	
func _on_collapse_started(duration: float) -> void:
	collapse_label.visible = true
	collapse_label.text = "Collapse: %d" % int(ceil(duration))
	
func _on_collapse_time_changed(time_left: float) -> void:
	collapse_label.visible = true
	collapse_label.text = "Collapse: %d" % int(ceil(time_left))
	
