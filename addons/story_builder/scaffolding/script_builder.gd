# addons/story_builder/scaffolding/script_builder.gd
extends RefCounted

func build_scripts(scripts: Array) -> void:
	for script_data in scripts:
		var path = script_data.get("path", "")
		var template_name = script_data.get("template", "")
		var variables = script_data.get("variables", {})
		
		if path.is_empty() or template_name.is_empty():
			continue
			
		var content = _generate_script_content(template_name, variables)
		if content.is_empty():
			# Fallback if template doesn't exist
			content = "extends Node\n\n# Generated script: " + template_name + "\n"
			
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			file.store_string(content)
			print("[Story Builder] Created script: ", path)
		else:
			printerr("[Story Builder] Failed to create script: ", path)

func _generate_script_content(template_name: String, variables: Dictionary) -> String:
	var template_path = "res://addons/story_builder/templates/" + template_name + ".gd.template"
	var template = ""
	
	if FileAccess.file_exists(template_path):
		var f = FileAccess.open(template_path, FileAccess.READ)
		if f:
			template = f.get_as_text()
	
	if template.is_empty():
		return ""
		
	for key in variables:
		var placeholder = "{{" + str(key).to_upper() + "}}"
		template = template.replace(placeholder, str(variables[key]))
		
	return template
