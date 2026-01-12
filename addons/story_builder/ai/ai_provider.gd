# addons/story_builder/ai/ai_provider.gd
extends RefCounted

signal request_completed(response: String)
signal request_failed(error: String)

var api_key: String = ""
var model_name: String = ""

func chat(messages: Array, system_prompt: String) -> void:
	push_error("chat() not implemented in base provider")

func get_name() -> String:
	return "BaseProvider"

func get_available_models() -> Array[String]:
	return []
