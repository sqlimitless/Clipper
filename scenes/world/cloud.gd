extends Node2D

var _velocity: Vector2


func _ready() -> void:
	var jitter := randf_range(
		1.0 - GameConstants.WIND_SPEED_VARIANCE,
		1.0 + GameConstants.WIND_SPEED_VARIANCE
	)
	_velocity = GameConstants.WIND_VELOCITY * jitter


func _process(delta: float) -> void:
	position += _velocity * delta
	if position.x > GameConstants.CLOUD_DESPAWN_X:
		queue_free()
