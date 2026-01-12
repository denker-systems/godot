# addons/story_builder/ai/ai_provider.gd
extends RefCounted

signal request_completed(response: String)
signal request_failed(error: String)

var api_key: String = ""

func chat(messages: Array, system_prompt: String) -> void:
	pass

func get_name() -> String:
	return "BaseProvider"
