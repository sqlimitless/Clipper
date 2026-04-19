extends Node2D

@export var cloud_scene: PackedScene
@export var cloud_textures: Array[Texture2D]

@export var initial_cloud_count: int = 5
@export var spawn_interval_range: Vector2 = Vector2(3.0, 7.0)

@export var spawn_x: float = -500.0
@export var initial_x_range: Vector2 = Vector2(-400.0, 2400.0)
@export var y_range: Vector2 = Vector2(-200.0, 400.0)
@export var scale_range: Vector2 = Vector2(0.8, 1.2)

var _timer: Timer


func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_spawn_at_edge)
	add_child(_timer)

	_populate_initial()
	_schedule_next()


func _populate_initial() -> void:
	for i in initial_cloud_count:
		var pos := Vector2(
			randf_range(initial_x_range.x, initial_x_range.y),
			randf_range(y_range.x, y_range.y)
		)
		_spawn(pos)


func _spawn_at_edge() -> void:
	var pos := Vector2(spawn_x, randf_range(y_range.x, y_range.y))
	_spawn(pos)
	_schedule_next()


func _schedule_next() -> void:
	_timer.start(randf_range(spawn_interval_range.x, spawn_interval_range.y))


func _spawn(pos: Vector2) -> void:
	if cloud_scene == null or cloud_textures.is_empty():
		push_warning("Clouds: cloud_scene or cloud_textures not set in Inspector")
		return

	var cloud: Node2D = cloud_scene.instantiate()
	cloud.position = pos
	var s := randf_range(scale_range.x, scale_range.y)
	cloud.scale = Vector2(s, s)
	add_child(cloud)

	var sprite: Sprite2D = cloud.get_node("Sprite2D")
	sprite.texture = cloud_textures.pick_random()
	sprite.flip_h = randf() < 0.5
