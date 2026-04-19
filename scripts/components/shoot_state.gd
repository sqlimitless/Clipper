extends State

@export var idle_state: State

var _sprite: AnimatedSprite2D
var _has_fired: bool = false


func enter() -> void:
	_sprite = player.get_node("AnimatedSprite2D")
	_sprite.play("ArcherShoot")
	_sprite.animation_finished.connect(_on_animation_finished)
	_has_fired = false

	var mouse_pos: Vector2 = player.get_global_mouse_position()
	_sprite.flip_h = mouse_pos.x < player.global_position.x


func exit() -> void:
	if _sprite.animation_finished.is_connected(_on_animation_finished):
		_sprite.animation_finished.disconnect(_on_animation_finished)


func process(_delta: float) -> void:
	if not _has_fired and _sprite.frame >= 4:
		_has_fired = true
		_fire_arrow()


func physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()


func _fire_arrow() -> void:
	var arrow_scene: PackedScene = player.arrow_scene
	if arrow_scene == null:
		return

	var arrow: Node2D = arrow_scene.instantiate()
	var spawn_point: Marker2D = player.get_node("ArrowSpawn")
	arrow.global_position = spawn_point.global_position

	var mouse_pos: Vector2 = player.get_global_mouse_position()
	var direction: Vector2 = (mouse_pos - player.global_position).normalized()
	var distance: float = player.global_position.distance_to(mouse_pos)
	arrow.setup(direction, distance)

	player.arrow_fired.emit(arrow)


func _on_animation_finished() -> void:
	state_machine.transition_to(idle_state)

