@tool
extends Control

@onready var chat_history: RichTextLabel = %ChatHistory
@onready var input_field: LineEdit = %InputField
@onready var send_button: Button = %SendButton
@onready var settings_button: Button = %SettingsButton
@onready var clear_button: Button = %ClearButton
@onready var copy_button: Button = %CopyButton
@onready var clear_generated_button: Button = %ClearGeneratedButton
@onready var generation_progress: ProgressBar = %GenerationProgress

const SettingsDialogScene = preload("res://addons/story_builder/ui/settings_dialog.tscn")
const ConfirmationDialogScene = preload("res://addons/story_builder/ui/confirmation_dialog.tscn")

var provider: RefCounted
var conversation_manager: RefCounted
var http_request: HTTPRequest
var settings_dialog: Window
var confirmation_dialog: Window
var project_generator: RefCounted

var current_provider_name: String = "Anthropic"
var current_model_name: String = ""
var api_keys: Dictionary = {
	"Anthropic": "",
	"OpenAI": "",
	"Gemini": ""
}
var last_generated_data: Dictionary = {}

const SETTINGS_PREFIX = "plugins/story_builder/"

func _ready() -> void:
	if not input_field:
		return # Guard for tool mode
	
	# Koppla signaler
	input_field.text_submitted.connect(_on_input_submitted)
	send_button.pressed.connect(_on_send_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	clear_button.pressed.connect(_on_clear_pressed)
	copy_button.pressed.connect(_on_copy_pressed)
	clear_generated_button.pressed.connect(_on_clear_generated_pressed)
	
	# Initiera Scaffolding
	var ProjectGenerator = load("res://addons/story_builder/scaffolding/project_generator.gd")
	project_generator = ProjectGenerator.new()
	project_generator.progress_updated.connect(_on_progress_updated)
	
	# Initiera HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Initiera Settings Dialog
	settings_dialog = SettingsDialogScene.instantiate()
	add_child(settings_dialog)
	settings_dialog.settings_saved.connect(_on_settings_saved)
	
	# Ladda inställningar
	_load_settings()
	
	# Initiera AI Provider
	_setup_provider(current_provider_name)
	
	# Initiera Conversation Manager
	var ConversationManager = load("res://addons/story_builder/ai/conversation_manager.gd")
	var system_prompt = _load_system_prompt()
	conversation_manager = ConversationManager.new(provider, system_prompt)
	
	conversation_manager.message_received.connect(add_message)
	conversation_manager.error_occurred.connect(func(err): add_message("Error", err))
	conversation_manager.generation_ready.connect(_on_generation_ready)
	
	# Initiera Confirmation Dialog
	confirmation_dialog = ConfirmationDialogScene.instantiate()
	add_child(confirmation_dialog)
	confirmation_dialog.confirmed_generation.connect(_on_confirmed_generation)
	
	# Ladda historik
	_load_chat_history()
	
	if chat_history.get_parsed_text().strip_edges().is_empty():
		add_message("System", "Welcome to Story Builder! Describe the game you want to create.")
	
	_check_api_status()

func _check_api_status() -> void:
	if api_keys[current_provider_name].is_empty():
		add_message("System", "[color=yellow]Warning: " + current_provider_name + " API key not set. Click 'Settings' to configure.[/color]")
	else:
		add_message("System", "[color=green]Ready: Using " + current_provider_name + " provider.[/color]")

func _setup_provider(p_name: String) -> void:
	var provider_script
	match p_name:
		"Anthropic":
			provider_script = load("res://addons/story_builder/ai/anthropic_provider.gd")
		"OpenAI":
			provider_script = load("res://addons/story_builder/ai/openai_provider.gd")
		"Gemini":
			provider_script = load("res://addons/story_builder/ai/gemini_provider.gd")
		_:
			push_error("Unknown provider: " + p_name)
			return
	
	provider = provider_script.new(http_request)
	provider.api_key = api_keys.get(p_name, "")
	provider.model_name = current_model_name
	
	if conversation_manager:
		conversation_manager.provider = provider
		# Återanslut signaler om de tappats
		if not provider.request_completed.is_connected(conversation_manager._on_ai_response):
			provider.request_completed.connect(conversation_manager._on_ai_response)
		if not provider.request_failed.is_connected(conversation_manager._on_ai_error):
			provider.request_failed.connect(conversation_manager._on_ai_error)

func _load_settings() -> void:
	var settings = EditorInterface.get_editor_settings()
	
	if settings.has_setting(SETTINGS_PREFIX + "active_provider"):
		current_provider_name = settings.get_setting(SETTINGS_PREFIX + "active_provider")
	
	if settings.has_setting(SETTINGS_PREFIX + "active_model"):
		current_model_name = settings.get_setting(SETTINGS_PREFIX + "active_model")
	
	for p in api_keys:
		var setting_path = SETTINGS_PREFIX + p.to_lower() + "_api_key"
		if settings.has_setting(setting_path):
			api_keys[p] = settings.get_setting(setting_path)
		elif p == "Anthropic":
			var env_key = OS.get_environment("ANTHROPIC_API_KEY")
			if not env_key.is_empty():
				api_keys[p] = env_key

func _load_system_prompt() -> String:
	var f = FileAccess.open("res://addons/story_builder/prompts/system_prompt.txt", FileAccess.READ)
	if f:
		return f.get_as_text()
	return "You are a Godot game design assistant."

func _on_settings_pressed() -> void:
	settings_dialog.setup(current_provider_name, current_model_name, api_keys)
	settings_dialog.popup_centered()

func _on_settings_saved(p_name: String, p_model: String, p_keys: Dictionary) -> void:
	current_provider_name = p_name
	current_model_name = p_model
	api_keys = p_keys
	
	_setup_provider(current_provider_name)
	
	var settings = EditorInterface.get_editor_settings()
	settings.set_setting(SETTINGS_PREFIX + "active_provider", current_provider_name)
	settings.set_setting(SETTINGS_PREFIX + "active_model", current_model_name)
	for p in api_keys:
		settings.set_setting(SETTINGS_PREFIX + p.to_lower() + "_api_key", api_keys[p])
	
	add_message("System", "Settings saved. Provider: " + current_provider_name + ", Model: " + current_model_name)
	_check_api_status()

func _on_clear_pressed() -> void:
	chat_history.clear()
	if conversation_manager:
		conversation_manager.messages = []
	if FileAccess.file_exists("user://story_builder_history.json"):
		DirAccess.remove_absolute("user://story_builder_history.json")
	add_message("System", "Chat history cleared.")

func _on_copy_pressed() -> void:
	var text = chat_history.get_parsed_text()
	DisplayServer.clipboard_set(text)
	add_message("System", "[color=green]Chat copied to clipboard![/color]")
	print("[StoryBuilder] Chat copied to clipboard (%d chars)" % text.length())

func _on_clear_generated_pressed() -> void:
	if last_generated_data.is_empty():
		add_message("System", "[color=yellow]No generated files to clear.[/color]")
		return
	
	print("=" .repeat(60))
	print("[StoryBuilder] === CLEARING GENERATED FILES ===")
	
	var deleted_count = 0
	
	# Delete scenes first (they may reference scripts)
	if last_generated_data.has("scenes"):
		for scene in last_generated_data["scenes"]:
			var path = scene.get("path", "")
			if not path.is_empty() and FileAccess.file_exists(path):
				DirAccess.remove_absolute(path)
				print("[StoryBuilder] Deleted scene: ", path)
				deleted_count += 1
	
	# Delete scripts
	if last_generated_data.has("scripts"):
		for script in last_generated_data["scripts"]:
			var path = script.get("path", "")
			if not path.is_empty() and FileAccess.file_exists(path):
				DirAccess.remove_absolute(path)
				print("[StoryBuilder] Deleted script: ", path)
				deleted_count += 1
	
	# Delete assets
	if last_generated_data.has("assets"):
		for asset in last_generated_data["assets"]:
			var path = asset.get("path", "")
			if not path.is_empty() and FileAccess.file_exists(path):
				DirAccess.remove_absolute(path)
				print("[StoryBuilder] Deleted asset: ", path)
				deleted_count += 1
	
	# Delete empty folders (reverse order to delete children first)
	if last_generated_data.has("folders"):
		var folders = last_generated_data["folders"].duplicate()
		folders.reverse()
		for folder in folders:
			var path = folder.get("path", "")
			if not path.is_empty() and DirAccess.dir_exists_absolute(path):
				var dir = DirAccess.open(path)
				if dir and dir.get_files().is_empty() and dir.get_directories().is_empty():
					DirAccess.remove_absolute(path)
					print("[StoryBuilder] Deleted folder: ", path)
					deleted_count += 1
	
	last_generated_data = {}
	
	print("[StoryBuilder] Deleted %d items" % deleted_count)
	print("=" .repeat(60))
	
	add_message("System", "[color=green]Cleared %d generated files/folders.[/color]" % deleted_count)
	
	# Refresh FileSystem
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()

func _on_input_submitted(new_text: String) -> void:
	if new_text.strip_edges().is_empty():
		return
	send_message(new_text)

func _on_send_pressed() -> void:
	var text = input_field.text
	if text.strip_edges().is_empty():
		return
	send_message(text)

func send_message(text: String) -> void:
	add_message("You", text)
	input_field.clear()
	if conversation_manager:
		conversation_manager.send_user_message(text)
	else:
		add_message("Error", "Conversation manager not initialized.")

func add_message(sender: String, text: String) -> void:
	var color = "#4A90E2" if sender == "You" else "#E2A04A"
	if sender == "System": color = "#888888"
	if sender == "Error": color = "#FF5555"
	
	chat_history.append_text("[color=" + color + "][b]" + sender + ":[/b][/color] " + text + "\n\n")
	_save_chat_history()

func _save_chat_history() -> void:
	if not conversation_manager: return
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
				var loaded_messages = data["messages"]
				if conversation_manager:
					conversation_manager.messages = loaded_messages
				for msg in loaded_messages:
					var sender = "You" if msg["role"] == "user" else "AI"
					add_message_silent(sender, msg["content"])

func add_message_silent(sender: String, text: String) -> void:
	var color = "#4A90E2" if sender == "You" else "#E2A04A"
	if sender == "System": color = "#888888"
	chat_history.append_text("[color=" + color + "][b]" + sender + ":[/b][/color] " + text + "\n\n")

func _on_generation_ready(project_data: Dictionary) -> void:
	add_message("System", "AI has suggested a project structure! Opening confirmation dialog...")
	if confirmation_dialog:
		confirmation_dialog.setup(project_data)
		confirmation_dialog.popup_centered()

func _on_confirmed_generation(project_data: Dictionary) -> void:
	add_message("System", "Starting project generation...")
	generation_progress.show()
	generation_progress.value = 0
	
	# Save for potential cleanup
	last_generated_data = project_data
	
	await get_tree().create_timer(0.1).timeout
	
	if project_generator:
		project_generator.generate(project_data)
		add_message("System", "Project generated successfully! Check your FileSystem dock.")
	else:
		add_message("Error", "Project generator not initialized.")
		
	await get_tree().create_timer(2.0).timeout
	generation_progress.hide()

func _on_progress_updated(step_name: String, percentage: float) -> void:
	if generation_progress:
		generation_progress.value = percentage
