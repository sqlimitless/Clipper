class_name HealthBar
extends Control

@export var tween_duration: float = 0.2

@onready var _fill: TextureRect = $FillArea/Fill

var _tween: Tween


func set_health(current: float, max_hp: float) -> void:
	var ratio: float = clampf(current / maxf(max_hp, 0.001), 0.0, 1.0)
	if _tween and _tween.is_valid():
		_tween.kill()
	if tween_duration > 0.0:
		_tween = create_tween()
		_tween.tween_property(_fill, "anchor_right", ratio, tween_duration)
	else:
		_fill.anchor_right = ratio
