class_name StateMachine
extends Node

@export var initial_state: State
@export var player: CharacterBody2D

var current_state: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			child.player = player
			child.state_machine = self

	if initial_state != null:
		current_state = initial_state
		current_state.enter()


func _unhandled_input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)


func _process(delta: float) -> void:
	if current_state != null:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_process(delta)


func transition_to(target_state: State) -> void:
	if current_state == target_state:
		return
	current_state.exit()
	current_state = target_state
	current_state.enter()
