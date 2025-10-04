extends Node3D

@onready var camera_target : Node3D = $"../Bus/CameraTarget"

func _process(_delta: float) -> void:
	position = camera_target.global_position
