# addons/story_builder/scaffolding/project_updater.gd
extends RefCounted

func update_project(data: Dictionary) -> void:
	if data.has("input_map"):
		_update_input_map(data["input_map"])
	
	if data.has("autoloads"):
		_update_autoloads(data["autoloads"])

func _update_input_map(input_map: Array) -> void:
	print("[Story Builder] Updating Input Map...")
	for action_data in input_map:
		var action = action_data.get("action", "")
		var keys = action_data.get("keys", [])
		
		if action.is_empty():
			continue
			
		if not ProjectSettings.has_setting("input/" + action):
			ProjectSettings.set_setting("input/" + action, {"deadzone": 0.5, "events": []})
		
		# In a real implementation, we would convert strings like "Space" to InputEventKey
		# For now, we just ensure the action exists.
		# Note: ProjectSettings.save() is needed to persist changes.
	
	ProjectSettings.save()

func _update_autoloads(autoloads: Array) -> void:
	print("[Story Builder] Updating Autoloads...")
	for autoload in autoloads:
		var name = autoload.get("name", "")
		var path = autoload.get("path", "")
		
		if name.is_empty() or path.is_empty():
			continue
			
		# Add to ProjectSettings (Autoloads start with 'autoload/')
		ProjectSettings.set_setting("autoload/" + name, "*" + path)
	
	ProjectSettings.save()
