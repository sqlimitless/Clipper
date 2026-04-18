extends CanvasLayer

@export var key_line_scene: PackedScene 

# 노드 참조
@onready var resolution_option = $PanelContainer/MarginContainer/VBoxContainer/ResolutionHBox/ResolutionOption
@onready var volume_slider = $PanelContainer/MarginContainer/VBoxContainer/VolumeHBox/VolumeSlider
@onready var key_list = $PanelContainer/MarginContainer/VBoxContainer/KeyList
@onready var close_button = $PanelContainer/MarginContainer/VBoxContainer/CloseButton

# 해상도 리스트
var resolutions: Dictionary = {
	"1280 x 720": Vector2i(1280, 720),
	"1600 x 900": Vector2i(1600, 900),
	"1920 x 1080": Vector2i(1920, 1080)
}

var my_keys = {
	"up":"Up",
	"down": "Down",
	"left": "Left",
	"right": "Right",
	"dodge": "Dodge",
	"attack": "Attack",
	"special": "Special",
	"weapon1": "Weapon 1",
	"weapon2": "Weapon 2",
	"weapon3": "Weapon 3",
	"weapon4": "Weapon 4",
}

func _ready():
	# 게임 일시 정지
	get_tree().paused = true
	
	# 1. 해상도 설정 초기화
	resolution_option.clear()
	var default_res_index = 0  # "1280 x 720"의 인덱스
	var count = 0
	
	for res_text in resolutions.keys():
		resolution_option.add_item(res_text)
		if res_text == "1280 x 720":
			default_res_index = count
		count += 1
	
	# 초기 해상도 강제 적용 (1280x720)
	resolution_option.selected = default_res_index
	_on_resolution_selected(default_res_index)
	resolution_option.item_selected.connect(_on_resolution_selected)
	
	# 2. 볼륨 설정 초기화
	var default_volume = 50
	volume_slider.value = default_volume
	_on_volume_changed(default_volume)
	volume_slider.value_changed.connect(_on_volume_changed)
	# 3. 키 설정 초기화 
	_create_key_list()
	
	# 4. 닫기 버튼 연결 
	close_button.pressed.connect(_on_close_pressed)

# 메뉴 제어 로직
func _on_close_pressed():
	get_tree().paused = false
	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"): # ESC 키 등
		_on_close_pressed()

# 해상도 로직
func _on_resolution_selected(index: int):
	var res_name = resolution_option.get_item_text(index)
	get_window().size = resolutions[res_name]
	get_window().move_to_center()

# 볼륨 로직
func _on_volume_changed(value: float):
	var master_bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))

# 키 리스트 생성 로직
func _create_key_list():
	for child in key_list.get_children():
		child.queue_free()
	
	if key_line_scene:
		for action in my_keys:
			var line = key_line_scene.instantiate()
			key_list.add_child(line)
			line.add_to_group("remap_buttons")
			line.setup(action, my_keys[action])
			
# 초기화 로직
func _on_reset_button_pressed():
	
	InputMap.load_from_project_settings()
	
	_on_resolution_selected(0)
	resolution_option.selected = 0
	
	volume_slider.value = 50
	_on_volume_changed(50)
	
	get_tree().call_group("remap_buttons", "_update_button_text")
