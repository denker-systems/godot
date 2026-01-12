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
	match type:
		"Node2D": return Node2D.new()
		"CharacterBody2D": return CharacterBody2D.new()
		"StaticBody2D": return StaticBody2D.new()
		"RigidBody2D": return RigidBody2D.new()
		"Area2D": return Area2D.new()
		"Sprite2D": return Sprite2D.new()
		"AnimatedSprite2D": return AnimatedSprite2D.new()
		"CollisionShape2D": return CollisionShape2D.new()
		"CollisionPolygon2D": return CollisionPolygon2D.new()
		"RayCast2D": return RayCast2D.new()
		"Camera2D": return Camera2D.new()
		"RemoteTransform2D": return RemoteTransform2D.new()
		"Node3D": return Node3D.new()
		"CharacterBody3D": return CharacterBody3D.new()
		"StaticBody3D": return StaticBody3D.new()
		"Camera3D": return Camera3D.new()
		"Control": return Control.new()
		"Button": return Button.new()
		"Label": return Label.new()
		"LineEdit": return LineEdit.new()
		"Panel": return Panel.new()
		"MarginContainer": return MarginContainer.new()
		"VBoxContainer": return VBoxContainer.new()
		"HBoxContainer": return HBoxContainer.new()
		"ScrollContainer": return ScrollContainer.new()
		"TextureRect": return TextureRect.new()
		"ColorRect": return ColorRect.new()
		"RichTextLabel": return RichTextLabel.new()
		"CanvasLayer": return CanvasLayer.new()
		"ParallaxBackground": return ParallaxLayer.new()
		"AnimationPlayer": return AnimationPlayer.new()
		"AudioStreamPlayer": return AudioStreamPlayer.new()
		"Marker2D": return Marker2D.new()
		"GPUParticles2D": return GPUParticles2D.new()
	
	# Attempt to use ClassDB for anything not matched
	if ClassDB.class_exists(type):
		return ClassDB.instantiate(type)
		
	return Node2D.new()
