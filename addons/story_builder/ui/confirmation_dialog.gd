@tool
extends Window

signal confirmed_generation(data: Dictionary)

@onready var tree: Tree = %StructureTree
@onready var generate_button: Button = %GenerateButton
@onready var cancel_button: Button = %CancelButton

var project_data: Dictionary

func _ready() -> void:
	generate_button.pressed.connect(_on_confirmed)
	cancel_button.pressed.connect(_on_canceled)
	close_requested.connect(_on_canceled)

func setup(data: Dictionary) -> void:
	project_data = data
	title = "Confirm Project Generation: " + data.get("project_name", "New Project")
	
	tree.clear()
	var root = tree.create_item()
	root.set_text(0, "res://")
	
	if data.has("folders"):
		for f in data["folders"]:
			var item = tree.create_item(root)
			item.set_text(0, f.get("path", "").replace("res://", ""))
			item.set_custom_color(0, Color.AQUAMARINE)
			
	if data.has("scripts"):
		for s in data["scripts"]:
			var item = tree.create_item(root)
			item.set_text(0, s.get("path", "").replace("res://", ""))
			item.set_custom_color(0, Color.GOLDENROD)

	if data.has("scenes"):
		for sc in data["scenes"]:
			var item = tree.create_item(root)
			item.set_text(0, sc.get("path", "").replace("res://", ""))
			item.set_custom_color(0, Color.LIGHT_CORAL)

func _on_confirmed() -> void:
	confirmed_generation.emit(project_data)
	hide()

func _on_canceled() -> void:
	hide()
