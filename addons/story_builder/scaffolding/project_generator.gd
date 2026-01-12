# addons/story_builder/scaffolding/project_generator.gd
extends RefCounted

signal progress_updated(step_name: String, percentage: float)

var folder_builder = load("res://addons/story_builder/scaffolding/folder_builder.gd").new()
var script_builder = load("res://addons/story_builder/scaffolding/script_builder.gd").new()
var scene_builder = load("res://addons/story_builder/scaffolding/scene_builder.gd").new()
var project_updater = load("res://addons/story_builder/scaffolding/project_updater.gd").new()
var asset_builder = load("res://addons/story_builder/scaffolding/asset_builder.gd").new()

func generate(data: Dictionary) -> void:
	print("[Story Builder] Starting generation for: ", data.get("project_name", "Unknown"))
	
	var total_steps = 5.0
	var current_step = 0.0
	
	if data.has("folders"):
		progress_updated.emit("Creating folders...", (current_step / total_steps) * 100.0)
		folder_builder.build_folders(data["folders"])
	current_step += 1.0
		
	if data.has("assets"):
		progress_updated.emit("Creating assets...", (current_step / total_steps) * 100.0)
		asset_builder.build_assets(data["assets"])
	current_step += 1.0
		
	if data.has("scripts"):
		progress_updated.emit("Generating scripts...", (current_step / total_steps) * 100.0)
		script_builder.build_scripts(data["scripts"])
	current_step += 1.0
		
	if data.has("scenes"):
		progress_updated.emit("Building scenes...", (current_step / total_steps) * 100.0)
		scene_builder.build_scenes(data["scenes"])
	current_step += 1.0
		
	progress_updated.emit("Finalizing project...", (current_step / total_steps) * 100.0)
	project_updater.update_project(data)
	current_step += 1.0
	
	progress_updated.emit("Complete!", 100.0)
	print("[Story Builder] Generation complete!")
