extends Node

func _ready() -> void:
	await get_tree().process_frame
	Global.dont_preload_materials = true
