extends CharacterBody2D

@export var speed: float = 300.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	move_and_slide()

	if input_dir.x != 0.0:
		_sprite.flip_h = input_dir.x < 0.0
