extends Node2D

@onready var _player: CharacterBody2D = $Player
@onready var _projectiles: Node2D = $Projectiles
@onready var _health_bar: HealthBar = $HUD/HUDRoot/TopLeft/HealthBar


func _ready() -> void:
	_player.arrow_fired.connect(_on_arrow_fired)
	_player.health_changed.connect(_health_bar.set_health)
	_health_bar.set_health(_player.current_hp, _player.max_hp)


func _on_arrow_fired(arrow: Node2D) -> void:
	_projectiles.add_child(arrow)
