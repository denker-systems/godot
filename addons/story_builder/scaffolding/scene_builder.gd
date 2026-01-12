# addons/story_builder/scaffolding/scene_builder.gd
extends RefCounted

func build_scenes(scenes: Array) -> void:
	for scene_data in scenes:
		var path = scene_data.get("path", "")
		var type = scene_data.get("type", "Node2D")
		var children = scene_data.get("children", [])
		var script_path = scene_data.get("script", "")
		
		if path.is_empty():
			continue
			
		var root = _create_node(type)
		if not root:
			continue
			
		root.name = path.get_file().get_basename()
		
		for child_type in children:
			var child = _create_node(child_type)
			if child:
				child.name = child_type
				root.add_child(child)
				child.owner = root
				
				# Basic setup for some common nodes
				if child is CollisionShape2D:
					var shape = RectangleShape2D.new()
					shape.size = Vector2(32, 32)
					child.shape = shape
		
		if not script_path.is_empty():
			if FileAccess.file_exists(script_path):
				root.set_script(load(script_path))
		
		var packed = PackedScene.new()
		packed.pack(root)
		var err = ResourceSaver.save(packed, path)
		
		if err == OK:
			print("[Story Builder] Created scene: ", path)
		else:
			printerr("[Story Builder] Failed to create scene: ", path, " Error: ", err)

func _create_node(type: String) -> Node:
	# This is a bit tricky programmatically. 
	# In a full version, we'd use ClassDB or a mapping.
	match type:
		"Node2D": return Node2D.new()
		"CharacterBody2D": return CharacterBody2D.new()
		"Sprite2D": return Sprite2D.new()
		"CollisionShape2D": return CollisionShape2D.new()
		"Area2D": return Area2D.new()
		"Camera2D": return Camera2D.new()
		"Control": return Control.new()
		"CanvasLayer": return CanvasLayer.new()
		"RichTextLabel": return RichTextLabel.new()
		"Button": return Button.new()
	return Node2D.new()
