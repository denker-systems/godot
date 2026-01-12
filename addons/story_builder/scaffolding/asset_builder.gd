# addons/story_builder/scaffolding/asset_builder.gd
extends RefCounted

func build_assets(assets: Array) -> void:
	for asset_data in assets:
		var path = asset_data.get("path", "")
		var type = asset_data.get("type", "placeholder_sprite")
		var size = asset_data.get("size", [64, 64])
		var color_hex = asset_data.get("color", "#4A90E2")
		
		if path.is_empty():
			continue
			
		match type:
			"placeholder_sprite":
				_create_placeholder_sprite(path, size, color_hex)

func _create_placeholder_sprite(path: String, size: Array, color_hex: String) -> void:
	# Ensure parent directory exists
	var dir_path = path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	
	var width = size[0] if size.size() > 0 else 64
	var height = size[1] if size.size() > 1 else 64
	
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	var color = Color.from_string(color_hex, Color.CORNFLOWER_BLUE)
	image.fill(color)
	
	# Add a simple border
	for x in range(width):
		image.set_pixel(x, 0, color.darkened(0.3))
		image.set_pixel(x, height - 1, color.darkened(0.3))
	for y in range(height):
		image.set_pixel(0, y, color.darkened(0.3))
		image.set_pixel(width - 1, y, color.darkened(0.3))
		
	var err = image.save_png(path)
	if err == OK:
		print("[Story Builder] Created placeholder sprite: ", path)
	else:
		printerr("[Story Builder] Failed to create sprite: ", path, " Error: ", err)
