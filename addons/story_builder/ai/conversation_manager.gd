# addons/story_builder/ai/conversation_manager.gd
extends RefCounted

signal message_received(sender: String, text: String)
signal generation_ready(project_data: Dictionary)
signal error_occurred(text: String)

var messages: Array = []
var provider: RefCounted # AIProvider
var system_prompt: String = ""

enum State { CLARIFYING, CONFIRMED, GENERATING }
var current_state: State = State.CLARIFYING

func _init(p_provider: RefCounted, p_system_prompt: String) -> void:
	provider = p_provider
	system_prompt = p_system_prompt
	provider.request_completed.connect(_on_ai_response)
	provider.request_failed.connect(_on_ai_error)

func send_user_message(text: String) -> void:
	messages.append({
		"role": "user",
		"content": text
	})
	
	provider.chat(messages, system_prompt)

func _on_ai_response(response: String) -> void:
	messages.append({
		"role": "assistant",
		"content": response
	})
	
	# Try to detect if response contains JSON for project structure
	if "{" in response and "}" in response:
		var project_data = _extract_json(response)
		if project_data:
			generation_ready.emit(project_data)
			return
			
	message_received.emit("AI", response)

func _on_ai_error(error: String) -> void:
	error_occurred.emit(error)

func _extract_json(text: String) -> Dictionary:
	var start = text.find("{")
	var end = text.rfind("}")
	if start == -1 or end == -1 or end < start:
		return {}
		
	var json_str = text.substr(start, end - start + 1)
	var json = JSON.new()
	if json.parse(json_str) == OK:
		var data = json.get_data()
		if data is Dictionary:
			return data
	return {}
