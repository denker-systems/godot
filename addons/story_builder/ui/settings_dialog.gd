# @tool
extends Window

signal settings_saved(provider_name: String, keys: Dictionary)

@onready var provider_option: OptionButton = %ProviderOption
@onready var anthropic_key_edit: LineEdit = %AnthropicKeyEdit
@onready var openai_key_edit: LineEdit = %OpenAIKeyEdit
@onready var gemini_key_edit: LineEdit = %GeminiKeyEdit
@onready var save_button: Button = %SaveButton
@onready var close_button: Button = %CloseButton

func _ready() -> void:
	save_button.pressed.connect(_on_save_pressed)
	close_button.pressed.connect(_on_close_pressed)
	close_requested.connect(_on_close_pressed)
	
	provider_option.clear()
	provider_option.add_item("Anthropic")
	provider_option.add_item("OpenAI")
	provider_option.add_item("Gemini")

func setup(current_provider: String, keys: Dictionary) -> void:
	for i in range(provider_option.item_count):
		if provider_option.get_item_text(i) == current_provider:
			provider_option.select(i)
			break
			
	anthropic_key_edit.text = keys.get("Anthropic", "")
	openai_key_edit.text = keys.get("OpenAI", "")
	gemini_key_edit.text = keys.get("Gemini", "")

func _on_save_pressed() -> void:
	var keys = {
		"Anthropic": anthropic_key_edit.text,
		"OpenAI": openai_key_edit.text,
		"Gemini": gemini_key_edit.text
	}
	settings_saved.emit(provider_option.get_item_text(provider_option.selected), keys)
	hide()

func _on_close_pressed() -> void:
	hide()
