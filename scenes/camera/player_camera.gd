extends Camera2D

@export var target: Node2D
@export var max_mouse_lean: float = 110.0
@export var lean_smoothing_speed: float = 5.0

var _current_lean: Vector2 = Vector2.ZERO


func _ready() -> void:
	make_current()


func _physics_process(_delta: float) -> void:
	if target != null:
		global_position = target.global_position + _current_lean


func _process(delta: float) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var center: Vector2 = viewport_size * 0.5

	var mouse_offset: Vector2 = ((mouse_pos - center) / center).clamp(
		Vector2(-1.0, -1.0),
		Vector2(1.0, 1.0)
	)

	var target_lean: Vector2 = mouse_offset * max_mouse_lean
	_current_lean = _current_lean.lerp(
		target_lean,
		clampf(lean_smoothing_speed * delta, 0.0, 1.0)
	)
