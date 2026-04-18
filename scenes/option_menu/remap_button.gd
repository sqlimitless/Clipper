extends HBoxContainer

@onready var action_label = $ActionLabel
@onready var input_button = $InputButton

var action_name: String = ""
var is_remapping: bool = false

func setup(action: String, display_name: String):
	action_name = action
	action_label.text = display_name
	_update_button_text()

func _update_button_text():
	if action_name == "": return
	
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		var event = events[0]
		var display_text = ""
		
		# 1. 키보드 키인 경우
		if event is InputEventKey:
			var code = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			display_text = OS.get_keycode_string(code)
		
		## 2. 마우스 버튼인 경우
		#elif event is InputEventMouseButton:
			#display_text = "Mouse " + str(event.button_index)
		
		# 3. 기타 예외 처리
		else:
			display_text = event.as_text().replace(" (Physical)", "").replace("-Physical", "").replace("Physical ", "")
			
		input_button.text = display_text
	else:
		input_button.text = "미지정"

func _on_input_button_pressed():
	is_remapping = true
	input_button.text = "..." 

func _input(event):
	if not is_remapping: return
	
	# 마우스 이동 무시
	if event is InputEventMouseMotion: return
	
	# 키보드 누름 또는 마우스 클릭 감지
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		# ESC 취소
		if event is InputEventKey and event.keycode == KEY_ESCAPE:
			is_remapping = false
			_update_button_text()
			get_viewport().set_input_as_handled()
			return
			
		# 1. 나의 기존 키 보관 (swap)
		var old_events = InputMap.action_get_events(action_name)
		var old_event = old_events[0] if old_events.size() > 0 else null
		
		# 2. 중복 체크 및 제거 
		var new_key_text = event.as_text()
		for other_action in InputMap.get_actions():
			if other_action.begins_with("ui_"): continue
			
			for other_event in InputMap.action_get_events(other_action):
				if other_event.as_text() == new_key_text:
					InputMap.action_erase_event(other_action, other_event)
					if old_event:
						InputMap.action_add_event(other_action, old_event)
					break
				
		# 3. 내 액션은 무조건 싹 비우고 새 키 하나만 추가 (중복 방지 핵심)
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		
		is_remapping = false
		get_tree().call_group("remap_buttons", "_update_button_text")
		get_viewport().set_input_as_handled()
