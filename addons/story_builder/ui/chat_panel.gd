# @tool
extends Control

@onready var chat_history: RichTextLabel = %ChatHistory
@onready var input_field: LineEdit = %InputField
@onready var send_button: Button = %SendButton
@onready var settings_button: Button = %SettingsButton
@onready var generation_progress: ProgressBar = %GenerationProgress

const SettingsDialog = preload("res://addons/story_builder/ui/settings_dialog.tscn")
const ConfirmationDialog = preload("res://addons/story_builder/ui/confirmation_dialog.tscn")

var provider: RefCounted
var conversation_manager: RefCounted
var http_request: HTTPRequest
var settings_dialog: Window
var confirmation_dialog: Window
var project_generator: RefCounted

var current_provider_name: String = "Anthropic"
var api_keys: Dictionary = {
	"Anthropic": "",
	"OpenAI": "",
	"Gemini": ""
}

const SETTING_PATH = "user://story_builder_settings.cfg"

func _ready() -> void:
	input_field.text_submitted.connect(_on_input_submitted)
	send_button.pressed.connect(_on_send_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	
	# Setup Scaffolding
	var ProjectGenerator = load("res://addons/story_builder/scaffolding/project_generator.gd")
	project_generator = ProjectGenerator.new()
	project_generator.progress_updated.connect(_on_progress_updated)
	
	# Setup HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Setup Settings Dialog
	settings_dialog = SettingsDialog.instantiate()
	add_child(settings_dialog)
	settings_dialog.settings_saved.connect(_on_settings_saved)
	
	# Load settings
	_load_settings()
	
	# Initial Provider Setup
	_setup_provider(current_provider_name)
	
	var ConversationManager = load("res://addons/story_builder/ai/conversation_manager.gd")
	var system_prompt = _load_system_prompt()
	conversation_manager = ConversationManager.new(provider, system_prompt)
	
	conversation_manager.message_received.connect(add_message)
	conversation_manager.error_occurred.connect(func(err): add_message("Error", err))
	conversation_manager.generation_ready.connect(_on_generation_ready)
	
	# Setup Confirmation Dialog
	confirmation_dialog = ConfirmationDialog.instantiate()
	add_child(confirmation_dialog)
	confirmation_dialog.confirmed_generation.connect(_on_confirmed_generation)
	
	_load_chat_history()
	
	add_message("System", "Welcome to Story Builder! Describe the game you want to create.")
	if api_keys[current_provider_name].is_empty():
		add_message("System", "[color=yellow]Warning: " + current_provider_name + " API key not set. Click 'Settings' to configure.[/color]")

func _setup_provider(provider_name: String) -> void:
	var provider_script
	match provider_name:
		"Anthropic":
			provider_script = load("res://addons/story_builder/ai/anthropic_provider.gd")
		"OpenAI":
			provider_script = load("res://addons/story_builder/ai/openai_provider.gd")
		"Gemini":
			provider_script = load("res://addons/story_builder/ai/gemini_provider.gd")
	
	provider = provider_script.new(http_request)
	provider.api_key = api_keys.get(provider_name, "")
	
	if conversation_manager:
		# Update provider in existing manager
		conversation_manager.provider = provider
		# Reconnect signals
		provider.request_completed.connect(conversation_manager._on_ai_response)
		provider.request_failed.connect(conversation_manager._on_ai_error)

func _load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTING_PATH)
	if err == OK:
		current_provider_name = config.get_value("settings", "provider", "Anthropic")
		api_keys["Anthropic"] = config.get_value("keys", "Anthropic", "")
		api_keys["OpenAI"] = config.get_value("keys", "OpenAI", "")
		api_keys["Gemini"] = config.get_value("keys", "Gemini", "")
	else:
		# Try environment for backward compatibility
		api_keys["Anthropic"] = OS.get_environment("ANTHROPIC_API_KEY")

func _on_settings_pressed() -> void:
	settings_dialog.setup(current_provider_name, api_keys)
	settings_dialog.popup_centered()

func _on_settings_saved(provider_name: String, keys: Dictionary) -> void:
	current_provider_name = provider_name
	api_keys = keys
	
	# Re-setup provider
	_setup_provider(current_provider_name)
	
	# Save to config file
	var config = ConfigFile.new()
	config.set_value("settings", "provider", current_provider_name)
	for p in api_keys:
		config.set_value("keys", p, api_keys[p])
	config.save(SETTING_PATH)
	
	add_message("System", "Settings updated and saved. Active provider: " + current_provider_name)

func _on_input_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	send_message(new_text)

func _on_send_pressed() -> void:
	var text = input_field.text
	if text.is_empty():
		return
	send_message(text)

func send_message(text: String) -> void:
	add_message("You", text)
	input_field.clear()
	conversation_manager.send_user_message(text)

func add_message(sender: String, text: String) -> void:
	var color = "#4A90E2" if sender == "You" else "#E2A04A"
	if sender == "System": color = "#888888"
	if sender == "Error": color = "#FF5555"
	
	chat_history.append_text("[color=" + color + "][b]" + sender + ":[/b][/color] " + text + "\n\n")
	_save_chat_history()

func _save_chat_history() -> void:
	var history_data = {
		"messages": conversation_manager.messages
	}
	var file = FileAccess.open("user://story_builder_history.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(history_data))

func _load_chat_history() -> void:
	if not FileAccess.file_exists("user://story_builder_history.json"):
		return
		
	var file = FileAccess.open("user://story_builder_history.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		if json.parse(file.get_as_text()) == OK:
			var data = json.get_data()
			if data is Dictionary and data.has("messages"):
				conversation_manager.messages = data["messages"]
				for msg in conversation_manager.messages:
					var sender = "You" if msg["role"] == "user" else "AI"
					add_message_silent(sender, msg["content"])

func add_message_silent(sender: String, text: String) -> void:
	var color = "#4A90E2" if sender == "You" else "#E2A04A"
	if sender == "System": color = "#888888"
	
	chat_history.append_text("[color=" + color + "][b]" + sender + ":[/b][/color] " + text + "\n\n")

func _on_generation_ready(project_data: Dictionary) -> void:
	add_message("System", "AI has suggested a project structure! Opening confirmation dialog...")
	confirmation_dialog.setup(project_data)
	confirmation_dialog.popup_centered()

func _on_confirmed_generation(project_data: Dictionary) -> void:
	add_message("System", "Starting project generation...")
	project_generator.generate(project_data)
	add_message("System", "Project generated successfully! Check your FileSystem dock.")
