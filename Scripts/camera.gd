extends Node3D

func _process(_delta: float) -> void:
	position.x = get_parent().global_transform.origin.x
	position.z = get_parent().global_transform.origin.z
	
	
