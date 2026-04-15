extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionButton
@onready var quit_button = $VBoxContainer/QuitButton


func _ready():
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func setup_button_animation(btn: TextureButton):
	# 크기 조절 기준점을 버튼의 중앙으로 설정
	btn.pivot_offset = btn.size / 2
	
	# 마우스 올릴 때 (커짐)
	btn.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1)
	)
	
	# 마우스 나갈 때 (원래대로)
	btn.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	)
	
	# 클릭할 때 (눌림)
	btn.button_down.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(0.9, 0.9), 0.05)
	)
	
	# 클릭 뗄 때 (다시 커짐)
	btn.button_up.connect(func():
		var tween = create_tween()
		tween.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.05)
	)

# 게임 시작
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

# 옵션 메뉴 열기
func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options/options.tscn")
	
# 게임 종료
func _on_quit_pressed():
	get_tree().quit()
 
