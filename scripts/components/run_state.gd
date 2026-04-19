extends State

@export var idle_state: State
@export var shoot_state: State


func enter() -> void:
	player.get_node("AnimatedSprite2D").play("ArcherRun")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		state_machine.transition_to(shoot_state)


func physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")

	if input_dir == Vector2.ZERO:
		state_machine.transition_to(idle_state)
		return

	if input_dir.x != 0.0:
		player.get_node("AnimatedSprite2D").flip_h = input_dir.x < 0.0

	player.velocity = input_dir * player.speed
	player.move_and_slide()
