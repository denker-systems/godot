@tool
extends EditorPlugin

const ChatPanel = preload("res://addons/story_builder/ui/chat_panel.tscn")
var chat_panel_instance

func _enter_tree() -> void:
	chat_panel_instance = ChatPanel.instantiate()
	# Add to the bottom panel
	add_control_to_bottom_panel(chat_panel_instance, "Story Builder")

func _exit_tree() -> void:
	if chat_panel_instance:
		remove_control_from_bottom_panel(chat_panel_instance)
		chat_panel_instance.queue_free()
