@tool
extends Node

@export_tool_button("Load materials") var load_materials_action = load_materials
@export var materials : Array[Material]
@onready var mesh_instance : MeshInstance3D = $SubViewportContainer/SubViewport/MeshInstance3D
@onready var progress : Slider = $Progress

func load_materials():
	materials.clear()
	load_materials_from_dir("res://")

func _ready() -> void:
	if Global.dont_preload_materials:
		self.queue_free()
	elif !Engine.is_editor_hint():
		var initial_time_scale := Engine.time_scale
		Engine.time_scale = 0.0
		print("showing ", materials.size(), " materials")
		for i in materials.size():
			var material := materials[i]
			progress.value = float(i) / float(materials.size())
			show_material(material)
			await get_tree().process_frame
		Engine.time_scale = initial_time_scale
		self.queue_free()

func load_materials_from_dir(path: String):
	var dir := DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			load_materials_from_dir(path + file_name + "/")
		elif ".tres" in file_name:
			var res = load(path + file_name)
			if res is Material:
				materials.push_back(res)
				print("Material loaded: ", path+file_name)
		file_name = dir.get_next()

func show_material(material : Material):
	mesh_instance.material_override = material
