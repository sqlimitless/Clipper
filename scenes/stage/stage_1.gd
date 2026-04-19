extends Node2D

@onready var _player: CharacterBody2D = $Player
@onready var _projectiles: Node2D = $Projectiles


func _ready() -> void:
	_player.arrow_fired.connect(_on_arrow_fired)


func _on_arrow_fired(arrow: Node2D) -> void:
	_projectiles.add_child(arrow)
