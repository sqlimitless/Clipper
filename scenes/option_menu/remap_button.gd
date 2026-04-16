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
		input_button.text = events[0].as_text().replace(" (Physical)", "")
	else:
		input_button.text = "미지정"

func _on_input_button_pressed():
	is_remapping = true
	input_button.text = "..." 

func _input(event):
	if is_remapping:
		# 1. 마우스 이동(MouseMotion) 무시 및 누르는 순간만 감지
		if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed() and not event.is_echo():
			
			# 2. ESC 키로 취소
			if event is InputEventKey and event.keycode == KEY_ESCAPE:
				is_remapping = false
				_update_button_text()
				get_viewport().set_input_as_handled()
				return

			# 3. 실제 키 변경 로직
			InputMap.action_erase_events(action_name)
			InputMap.action_add_event(action_name, event)
			
			is_remapping = false
			
			if get_parent():
				get_parent().propagate_call("_update_button_text")
			else:
				_update_button_text()
				
			get_viewport().set_input_as_handled()
