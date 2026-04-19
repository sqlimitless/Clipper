extends Area2D

@export var max_arrow_speed: float = 600.0
@export var fake_gravity: float = 400.0
@export var max_height_z_index: int = 10

var _ground_direction: Vector2 = Vector2.RIGHT
var _ground_speed: float = 0.0
var _vertical_speed: float = 0.0
var _height: float = 0.0
var _peak_height: float = 0.0

var _sprite: Sprite2D


func setup(dir: Vector2, distance: float) -> void:
	_ground_direction = dir.normalized()

	var max_range: float = max_arrow_speed * max_arrow_speed / fake_gravity
	var clamped_distance: float = minf(distance, max_range)

	var speed: float = sqrt(clamped_distance * fake_gravity)
	_ground_speed = speed * 0.7071
	_vertical_speed = speed * 0.7071

	_peak_height = _vertical_speed * _vertical_speed / (2.0 * fake_gravity)


func _ready() -> void:
	_sprite = $Sprite2D


func _process(delta: float) -> void:
	position += _ground_direction * _ground_speed * delta

	_vertical_speed -= fake_gravity * delta
	_height += _vertical_speed * delta

	if _height <= 0.0 and _vertical_speed < 0.0:
		queue_free()
		return

	_height = maxf(_height, 0.0)

	_sprite.offset.y = -_height
	z_index = int(remap(
		clampf(_height, 0.0, _peak_height),
		0.0, _peak_height,
		0.0, float(max_height_z_index)
	))

	var vx: float = _ground_direction.x * _ground_speed
	var vy: float = _ground_direction.y * _ground_speed - _vertical_speed
	_sprite.rotation = atan2(vy, vx)
