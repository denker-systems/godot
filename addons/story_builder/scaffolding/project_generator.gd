# addons/story_builder/scaffolding/project_generator.gd
extends RefCounted

signal progress_updated(step_name: String, percentage: float)

var folder_builder = load("res://addons/story_builder/scaffolding/folder_builder.gd").new()
var script_builder = load("res://addons/story_builder/scaffolding/script_builder.gd").new()
var scene_builder = load("res://addons/story_builder/scaffolding/scene_builder.gd").new()
var project_updater = load("res://addons/story_builder/scaffolding/project_updater.gd").new()
var asset_builder = load("res://addons/story_builder/scaffolding/asset_builder.gd").new()

func generate(data: Dictionary) -> void:
	print("=" .repeat(60))
	print("[ProjectGenerator] === STARTING PROJECT GENERATION ===")
	print("[ProjectGenerator] Project: ", data.get("project_name", "Unknown"))
	print("[ProjectGenerator] Game Type: ", data.get("game_type", "Unknown"))
	print("=" .repeat(60))
	
	var total_steps = 5.0
	var current_step = 0.0
	
	if data.has("folders"):
		var folders = data["folders"]
		print("[ProjectGenerator] Creating %d folders..." % folders.size())
		progress_updated.emit("Creating folders...", (current_step / total_steps) * 100.0)
		folder_builder.build_folders(folders)
	else:
		print("[ProjectGenerator] No folders in data")
	current_step += 1.0
		
	if data.has("assets"):
		var assets = data["assets"]
		print("[ProjectGenerator] Creating %d assets..." % assets.size())
		progress_updated.emit("Creating assets...", (current_step / total_steps) * 100.0)
		asset_builder.build_assets(assets)
	else:
		print("[ProjectGenerator] No assets in data")
	current_step += 1.0
		
	if data.has("scripts"):
		var scripts = data["scripts"]
		print("[ProjectGenerator] Generating %d scripts..." % scripts.size())
		progress_updated.emit("Generating scripts...", (current_step / total_steps) * 100.0)
		script_builder.build_scripts(scripts)
	else:
		print("[ProjectGenerator] No scripts in data")
	current_step += 1.0
		
	if data.has("scenes"):
		var scenes = data["scenes"]
		print("[ProjectGenerator] Building %d scenes..." % scenes.size())
		progress_updated.emit("Building scenes...", (current_step / total_steps) * 100.0)
		scene_builder.build_scenes(scenes)
	else:
		print("[ProjectGenerator] No scenes in data")
	current_step += 1.0
		
	print("[ProjectGenerator] Finalizing project settings...")
	progress_updated.emit("Finalizing project...", (current_step / total_steps) * 100.0)
	project_updater.update_project(data)
	current_step += 1.0
	
	progress_updated.emit("Complete!", 100.0)
	print("=" .repeat(60))
	print("[ProjectGenerator] === GENERATION COMPLETE ===")
	print("=" .repeat(60))
	
	# Refresh the FileSystem dock
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
