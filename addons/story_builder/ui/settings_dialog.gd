@tool
extends Window

signal settings_saved(provider_name: String, model_name: String, keys: Dictionary)

@onready var provider_option: OptionButton = %ProviderOption
@onready var model_option: OptionButton = %ModelOption
@onready var anthropic_key_edit: LineEdit = %AnthropicKeyEdit
@onready var openai_key_edit: LineEdit = %OpenAIKeyEdit
@onready var gemini_key_edit: LineEdit = %GeminiKeyEdit
@onready var save_button: Button = %SaveButton
@onready var close_button: Button = %CloseButton

var provider_models := {
	"Anthropic": [
		"claude-sonnet-4-5-20250929",
		"claude-sonnet-4-20250514",
		"claude-3-5-haiku-20241022",
		"claude-3-opus-20240229"
	],
	"OpenAI": [
		"gpt-4o",
		"gpt-4o-mini",
		"gpt-4-turbo"
	],
	"Gemini": [
		"gemini-1.5-pro",
		"gemini-1.5-flash"
	]
}

func _ready() -> void:
	save_button.pressed.connect(_on_save_pressed)
	close_button.pressed.connect(_on_close_pressed)
	close_requested.connect(_on_close_pressed)
	provider_option.item_selected.connect(_on_provider_selected)
	
	provider_option.clear()
	provider_option.add_item("Anthropic")
	provider_option.add_item("OpenAI")
	provider_option.add_item("Gemini")
	_update_model_list("Anthropic")

func setup(current_provider: String, current_model: String, keys: Dictionary) -> void:
	for i in range(provider_option.item_count):
		if provider_option.get_item_text(i) == current_provider:
			provider_option.select(i)
			break
	_update_model_list(current_provider)
	_select_model(current_model)
			
	anthropic_key_edit.text = keys.get("Anthropic", "")
	openai_key_edit.text = keys.get("OpenAI", "")
	gemini_key_edit.text = keys.get("Gemini", "")

func _on_provider_selected(index: int) -> void:
	_update_model_list(provider_option.get_item_text(index))
	_select_model("")

func _update_model_list(provider_name: String) -> void:
	model_option.clear()
	if provider_models.has(provider_name):
		for m in provider_models[provider_name]:
			model_option.add_item(m)

func _select_model(model_name: String) -> void:
	if model_option.item_count <= 0:
		return
	if model_name.is_empty():
		model_option.select(0)
		return
	for i in range(model_option.item_count):
		if model_option.get_item_text(i) == model_name:
			model_option.select(i)
			return
	model_option.select(0)

func _on_save_pressed() -> void:
	var keys = {
		"Anthropic": anthropic_key_edit.text,
		"OpenAI": openai_key_edit.text,
		"Gemini": gemini_key_edit.text
	}
	var provider_name = provider_option.get_item_text(provider_option.selected)
	var model_name = model_option.get_item_text(model_option.selected) if model_option.selected >= 0 else ""
	settings_saved.emit(provider_name, model_name, keys)
	hide()

func _on_close_pressed() -> void:
	hide()
