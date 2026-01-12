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
	print("[ConversationManager] Received AI response (%d chars)" % response.length())
	messages.append({
		"role": "assistant",
		"content": response
	})
	
	# Try to detect if response contains JSON for project structure
	if "{" in response and "}" in response:
		print("[ConversationManager] Response contains JSON, attempting to extract...")
		var project_data = _extract_json(response)
		if project_data:
			print("[ConversationManager] Valid project JSON extracted!")
			print("[ConversationManager] Project: ", project_data.get("project_name", "Unknown"))
			print("[ConversationManager] Folders: ", project_data.get("folders", []).size())
			print("[ConversationManager] Scenes: ", project_data.get("scenes", []).size())
			print("[ConversationManager] Scripts: ", project_data.get("scripts", []).size())
			generation_ready.emit(project_data)
			return
		else:
			print("[ConversationManager] JSON extraction failed, treating as normal message")
			
	message_received.emit("AI", response)

func _on_ai_error(error: String) -> void:
	error_occurred.emit(error)

func _extract_json(text: String) -> Dictionary:
	var start = text.find("{")
	var end = text.rfind("}")
	if start == -1 or end == -1 or end < start:
		print("[ConversationManager] No valid JSON braces found")
		return {}
		
	var json_str = text.substr(start, end - start + 1)
	print("[ConversationManager] Extracted JSON string (%d chars)" % json_str.length())
	
	var json = JSON.new()
	var parse_result = json.parse(json_str)
	if parse_result == OK:
		var data = json.get_data()
		if data is Dictionary:
			# Check if it has required project structure keys
			if data.has("project_name") or data.has("folders") or data.has("scenes"):
				print("[ConversationManager] Valid project structure detected")
				return data
			else:
				print("[ConversationManager] JSON parsed but not a project structure")
	else:
		print("[ConversationManager] JSON parse error: ", json.get_error_message())
	return {}
