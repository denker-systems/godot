# addons/story_builder/scaffolding/folder_builder.gd
extends RefCounted

func build_folders(folders: Array) -> void:
	for folder in folders:
		var path = folder.get("path", "")
		if path.is_empty():
			continue
			
		if not DirAccess.dir_exists_absolute(path):
			var err = DirAccess.make_dir_recursive_absolute(path)
			if err != OK:
				printerr("[Story Builder] Failed to create folder: ", path, " Error: ", err)
			else:
				print("[Story Builder] Created folder: ", path)
