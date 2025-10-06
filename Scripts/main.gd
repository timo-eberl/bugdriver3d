extends Node3D

@onready var ui : UI = $HUD/UI#TODO
@onready var ambient_audio_player: AudioStreamPlayer3D = $AmbientAudioPlayer

@onready var level: Node3D = $level

@onready var mud_script : Script = preload("res://Scripts/mud.gd")

@onready var grass_mat : ShaderMaterial = preload("res://Materials/grass.tres")
@onready var mushroom_mat : ShaderMaterial = preload("res://Materials/mushroom.tres")
@onready var puddle_mat : ShaderMaterial = preload("res://Materials/puddle.tres")
@onready var rock_mat : ShaderMaterial = preload("res://Materials/rock.tres")
@onready var terrain_mat : ShaderMaterial = preload("res://Materials/terrain.tres")
@onready var treestump_mat : ShaderMaterial = preload("res://Materials/tree_stump.tres")

func _ready() -> void:
	ambient_audio_player.play()
	_prepare_level()


func _process(delta: float) -> void:
	var current_progress = ui.current_progress
	
	grass_mat.set_shader_parameter("snow_amount", current_progress)
	mushroom_mat.set_shader_parameter("snow_amount", current_progress)
	puddle_mat.set_shader_parameter("snow_amount", current_progress)
	rock_mat.set_shader_parameter("snow_amount", current_progress)
	terrain_mat.set_shader_parameter("snow_amount", current_progress)
	treestump_mat.set_shader_parameter("snow_amount", current_progress)


func _on_bus_bug_collected() -> void:
	pass


func _on_ui_round_over() -> void:
	ambient_audio_player.play()


#func _on_ui_round_start() -> void:
	#ambient_audio_player.stop() 


func _prepare_level() -> void:
	for node : MeshInstance3D in level.get_children():
		if node.name.contains("grass"):
			node.mesh.surface_set_material(0, grass_mat)
		
		if node.name.contains("mushroom"):
			node.get_child(0).add_to_group("Mushroom")
			
			node.mesh.surface_set_material(0, mushroom_mat)
			
		if node.name.contains("puddle"):
			node.set_script(mud_script)
			var area_3d = Area3D.new()
			node.add_child(area_3d)
			area_3d.set_collision_mask_value(2, true)
			var shape = node.get_node("StaticBody3D/CollisionShape3D")
			shape.reparent(area_3d)
			
			node.area = area_3d
			node.connect_signals()
			
			node.mesh.surface_set_material(0, puddle_mat)
			
		if node.name.contains("rock"):
			node.mesh.surface_set_material(0, rock_mat)
			
		if node.name.contains("terrain"):
			node.mesh.surface_set_material(0, terrain_mat)
		
		if node.name.contains("treestump"):
			node.mesh.surface_set_material(0, treestump_mat)
