extends CharacterBody2D

signal arrow_fired(arrow: Node2D)
signal health_changed(current: float, max_hp: float)
signal died

@export var speed: float = 300.0
@export var arrow_scene: PackedScene
@export var max_hp: float = 100.0

var current_hp: float


func _ready() -> void:
	current_hp = max_hp
	health_changed.emit(current_hp, max_hp)


func take_damage(amount: float) -> void:
	if current_hp <= 0.0:
		return
	current_hp = clampf(current_hp - amount, 0.0, max_hp)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0.0:
		died.emit()


func heal(amount: float) -> void:
	current_hp = clampf(current_hp + amount, 0.0, max_hp)
	health_changed.emit(current_hp, max_hp)
