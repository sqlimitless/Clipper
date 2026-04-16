extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionButton
@onready var quit_button = $VBoxContainer/QuitButton


func _ready():
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

# 게임 시작
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

# 옵션 메뉴 열기
func _on_options_pressed():
	var options_scene = load("res://scenes/option_menu/option_menu.tscn")
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	
# 게임 종료
func _on_quit_pressed():
	get_tree().quit()
