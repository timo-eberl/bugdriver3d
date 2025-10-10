@tool
extends Node3D
class_name CameraController

@export var distance_idle := 17.0
@export var distance_driving := 38.0
@export_range(0,1) var distance_interpolator := 0.0

@onready var camera_target : Node3D = $"../Bus/CameraTarget"
@onready var camera : Camera3D = $Camera3D

func _process(_delta: float) -> void:
	#global_position = camera_target.global_position
	#camera.position.z = lerp(distance_idle, distance_driving, distance_interpolator)
	pass
