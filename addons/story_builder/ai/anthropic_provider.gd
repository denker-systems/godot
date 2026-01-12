# addons/story_builder/ai/anthropic_provider.gd
extends "res://addons/story_builder/ai/ai_provider.gd"

const API_URL = "https://api.anthropic.com/v1/messages"
const ANTHROPIC_VERSION = "2023-06-01"

var http_request: HTTPRequest

func _init(p_http_request: HTTPRequest) -> void:
	http_request = p_http_request
	http_request.request_completed.connect(_on_request_completed)

func get_name() -> String:
	return "Anthropic"

func chat(messages: Array, system_prompt: String) -> void:
	if api_key.is_empty():
		request_failed.emit("Anthropic API key is missing.")
		return

	var headers = [
		"Content-Type: application/json",
		"x-api-key: " + api_key,
		"anthropic-version: " + ANTHROPIC_VERSION
	]

	var body = {
		"model": "claude-3-5-sonnet-20241022",
		"max_tokens": 4096,
		"system": system_prompt,
		"messages": messages
	}

	var error = http_request.request(API_URL, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	if error != OK:
		request_failed.emit("Failed to send request to Anthropic: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		request_failed.emit("HTTPRequest failed with result: " + str(result))
		return

	var response_text = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_err = json.parse(response_text)
	
	if parse_err != OK:
		request_failed.emit("Failed to parse Anthropic response: " + json.get_error_message())
		return

	var response_data = json.get_data()
	
	if response_code != 200:
		var err_msg = "Anthropic API error (" + str(response_code) + ")"
		if response_data.has("error") and response_data["error"].has("message"):
			err_msg += ": " + response_data["error"]["message"]
		request_failed.emit(err_msg)
		return

	if response_data.has("content") and response_data["content"].size() > 0:
		var content = response_data["content"][0]["text"]
		request_completed.emit(content)
	else:
		request_failed.emit("Unexpected response format from Anthropic.")
