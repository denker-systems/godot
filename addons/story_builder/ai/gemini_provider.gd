# addons/story_builder/ai/gemini_provider.gd
extends "res://addons/story_builder/ai/ai_provider.gd"

# Note: Gemini uses a different URL structure with the key in the URL
const API_URL_BASE = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key="

var http_request: HTTPRequest

func _init(p_http_request: HTTPRequest) -> void:
	http_request = p_http_request
	http_request.request_completed.connect(_on_request_completed)

func get_name() -> String:
	return "Gemini"

func chat(messages: Array, system_prompt: String) -> void:
	if api_key.is_empty():
		request_failed.emit("Gemini API key is missing.")
		return

	var headers = ["Content-Type: application/json"]
	var url = API_URL_BASE + api_key

	# Convert messages to Gemini format
	var contents = []
	# Gemini usually puts system instruction separately or as first message
	# In 1.5 Pro we can use system_instruction in the body
	
	for msg in messages:
		var role = "user" if msg["role"] == "user" else "model"
		contents.append({
			"role": role,
			"parts": [{"text": msg["content"]}]
		})

	var body = {
		"system_instruction": {
			"parts": [{"text": system_prompt}]
		},
		"contents": contents,
		"generationConfig": {
			"response_mime_type": "application/json" if "JSON" in system_prompt else "text/plain"
		}
	}

	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	if error != OK:
		request_failed.emit("Failed to send request to Gemini: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		request_failed.emit("HTTPRequest failed with result: " + str(result))
		return

	var response_text = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_err = json.parse(response_text)
	
	if parse_err != OK:
		request_failed.emit("Failed to parse Gemini response: " + json.get_error_message())
		return

	var response_data = json.get_data()
	
	if response_code != 200:
		var err_msg = "Gemini API error (" + str(response_code) + ")"
		if response_data is Array and response_data.size() > 0 and response_data[0].has("error"):
			err_msg += ": " + response_data[0]["error"]["message"]
		elif response_data is Dictionary and response_data.has("error"):
			err_msg += ": " + response_data["error"]["message"]
		request_failed.emit(err_msg)
		return

	if response_data.has("candidates") and response_data["candidates"].size() > 0:
		var content = response_data["candidates"][0]["content"]["parts"][0]["text"]
		request_completed.emit(content)
	else:
		request_failed.emit("Unexpected response format from Gemini.")
