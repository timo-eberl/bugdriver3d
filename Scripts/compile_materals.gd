extends Node
class_name CompileMaterials

signal finished

@onready var mesh_instance : MeshInstance3D = $SubViewportContainer/SubViewport/MeshInstance3D
@onready var progress : Slider = $Progress

var materials : Array[Material]

func collect_materials_in_node(node : Node):
	for property_name in node.get_property_list():
		var value = node.get(property_name.name)
		if value is Material:
			#print("Material found in ", node.name, ": ", property_name.name, " = ", value)
			materials.push_back(value)
	for child in node.get_children():
		collect_materials_in_node(child)

func _ready() -> void:
	if Global.dont_preload_materials:
		emit_signal("finished")
		self.queue_free()
	else:
		materials.clear()
		# get all materials in currently loaded scene
		collect_materials_in_node(get_tree().current_scene)
		
		var initial_time_scale := Engine.time_scale
		Engine.time_scale = 0.0
		print("showing ", materials.size(), " materials")
		for i in materials.size():
			var material := materials[i]
			progress.value = float(i) / float(materials.size())
			mesh_instance.material_override = material
			await get_tree().process_frame
		Engine.time_scale = initial_time_scale
		emit_signal("finished")
		self.queue_free()
