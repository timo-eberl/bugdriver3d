extends Node3D

@onready var ui : UI = $HUD/UI#TODO
@onready var ambient_audio_player: AudioStreamPlayer3D = $AmbientAudioPlayer

@onready var level: Node3D = $level

@onready var mud_script : Script = preload("res://Scripts/mud.gd")

func _ready() -> void:
	ambient_audio_player.play()
	_prepare_level()


func _on_bus_bug_collected() -> void:
	pass


func _on_ui_round_over() -> void:
	ambient_audio_player.play()


#func _on_ui_round_start() -> void:
	#ambient_audio_player.stop() 


func _prepare_level() -> void:
	for node in level.get_children():
		if node.name.contains("puddle"):
			node.set_script(mud_script)
			var area_3d = Area3D.new()
			node.add_child(area_3d)
			area_3d.set_collision_mask_value(2, true)
			var shape = node.get_node("StaticBody3D/CollisionShape3D")
			shape.reparent(area_3d)
			
			node.area = area_3d
			node.connect_signals()

		if node.name.contains("mushroom"):
			node.get_child(0).add_to_group("Mushroom")
