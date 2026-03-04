extends Node

enum State { HUB, DIVE, WORLD, LOADING }
var state: State = State.HUB

@export var hub_scene: PackedScene
@export var dive_scene: PackedScene

var _scene_root: Node
var _current_scene: Node

func init(scene_root: Node) -> void:
	_scene_root = scene_root

func _set_scene(packed: PackedScene) -> void:
	if _scene_root == null:
		push_error("GameFlow not initialized. Call GameFlow.init(Main/SceneRoot) in Main._ready().")
		return

	if _current_scene and is_instance_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null

	_current_scene = packed.instantiate()
	_scene_root.add_child(_current_scene)

	# Let the scene enter the tree / run _ready before asking for spawn points
	call_deferred("_place_player")

func goto_hub() -> void:
	state = State.HUB
	_set_scene(hub_scene)

func start_dive() -> void:
	state = State.DIVE
	Run.begin_dive()
	_set_scene(dive_scene)

func get_player() -> CharacterBody2D:
	var p := get_tree().root.get_node_or_null("Main/ActorsRoot/Player") as CharacterBody2D
	if p == null:
		push_error("Player not found at Main/ActorsRoot/Player")
	return p

func _place_player() -> void:
	var player := get_player()
	if player == null or _current_scene == null:
		return

	if _current_scene.has_method("get_spawn"):
		player.global_position = _current_scene.call("get_spawn")
		player.velocity = Vector2.ZERO
	else:
		player.global_position = Vector2.ZERO
		player.velocity = Vector2.ZERO
