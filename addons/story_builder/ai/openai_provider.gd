# addons/story_builder/ai/openai_provider.gd
extends "res://addons/story_builder/ai/ai_provider.gd"

const API_URL = "https://api.openai.com/v1/chat/completions"

var http_request: HTTPRequest

func _init(p_http_request: HTTPRequest) -> void:
	http_request = p_http_request
	http_request.request_completed.connect(_on_request_completed)

func get_name() -> String:
	return "OpenAI"

func chat(messages: Array, system_prompt: String) -> void:
	if api_key.is_empty():
		request_failed.emit("OpenAI API key is missing.")
		return

	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]

	var formatted_messages = [{"role": "system", "content": system_prompt}]
	formatted_messages.append_array(messages)

	var body = {
		"model": "gpt-4o",
		"messages": formatted_messages,
		"response_format": { "type": "json_object" } if "JSON" in system_prompt else null
	}

	var error = http_request.request(API_URL, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	if error != OK:
		request_failed.emit("Failed to send request to OpenAI: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		request_failed.emit("HTTPRequest failed with result: " + str(result))
		return

	var response_text = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_err = json.parse(response_text)
	
	if parse_err != OK:
		request_failed.emit("Failed to parse OpenAI response: " + json.get_error_message())
		return

	var response_data = json.get_data()
	
	if response_code != 200:
		var err_msg = "OpenAI API error (" + str(response_code) + ")"
		if response_data.has("error") and response_data["error"].has("message"):
			err_msg += ": " + response_data["error"]["message"]
		request_failed.emit(err_msg)
		return

	if response_data.has("choices") and response_data["choices"].size() > 0:
		var content = response_data["choices"][0]["message"]["content"]
		request_completed.emit(content)
	else:
		request_failed.emit("Unexpected response format from OpenAI.")
